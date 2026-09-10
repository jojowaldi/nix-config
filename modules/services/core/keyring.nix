{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  # the systemd *user* service runs for every user, so every one of them needs a
  # readable copy - root-only ownership silently unlocks nothing
  users = lib.filter (spec: spec.username != "root") config.hostSpec.users;

  # one unit for all users, so pick the secret at runtime (sops default location)
  pwFile = ''/run/secrets/keyring_password_"$USER"'';

  # Every keyring other than "login" auto-unlocks when its password is stored in
  # the login keyring under attribute keyring=LOCAL:/keyrings/<name>.keyring
  # (gnome-keyring's "automatically unlock" checkbox does exactly this).
  # ponytail: assumes all keyrings share the sops password; per-keyring
  # passwords would need one sops key each. No eager unlock either - the D-Bus
  # Unlock prompt object only exists on the calling connection, so a script
  # cannot drive it; keyrings unlock silently on first access instead.
  chainOtherKeyrings = pkgs.writeShellScript "gnome-keyring-chain" ''
    export PATH=${
      lib.makeBinPath [
        pkgs.libsecret
        pkgs.systemd
        pkgs.coreutils
      ]
    }
    PW_FILE=${pwFile}
    [ -r "$PW_FILE" ] || exit 0
    PW="$(cat "$PW_FILE")"

    # gnome-keyring ships its own D-Bus activation file for org.freedesktop.secrets
    # (plain "--start", no password) plus XDG autostart entries that launch the
    # same. Any query against the name while it's still unowned - even our own
    # get-property poll below - makes D-Bus activate THAT one, and it wins the
    # name outright: our --unlock daemon (started a moment earlier by ExecStart)
    # is left running but nameless, "another secret service is running".
    # GetConnectionUnixProcessID asks the bus about a name rather than calling
    # the name itself, so it can't trigger that activation - safe to poll with.
    us="$(systemctl --user show gnome-keyring-autounlock.service -p MainPID --value)"
    owner=""
    for _ in $(seq 50); do
      owner="$(busctl --user call org.freedesktop.DBus /org/freedesktop/DBus \
        org.freedesktop.DBus GetConnectionUnixProcessID s org.freedesktop.secrets \
        2>/dev/null | cut -d' ' -f2)"
      [ -n "$owner" ] && break
      sleep 0.1
    done

    # Someone else's daemon won the name before ours claimed it: kill the
    # impostor and restart ourselves onto the now-empty name. Restarting from
    # inside our own ExecStartPost (backgrounded, detached) rather than looping
    # here - once MainPID is gone this process is going down with it anyway.
    if [ -n "$owner" ] && [ "$owner" != "$us" ]; then
      kill -9 "$owner" 2>/dev/null || true
      systemctl --user restart gnome-keyring-autounlock.service &
      disown
      exit 0
    fi

    # Re-stored on every start: gnome-keyring deletes the entry again if the
    # password turns out to be wrong for that keyring (and then prompts), so a
    # keyring that keeps prompting has a password differing from the sops one.
    for f in "$HOME"/.local/share/keyrings/*.keyring; do
      [ -e "$f" ] || continue
      name="$(basename "$f" .keyring)"
      if [ "$name" = "login" ]; then continue; fi
      printf %s "$PW" | secret-tool store --label="Unlock password for: $name" \
        --collection=/org/freedesktop/secrets/collection/login \
        keyring "LOCAL:/keyrings/$name.keyring"
    done
  '';
in
{
  services.gnome.gnome-keyring.enable = true;

  sops.secrets = lib.listToAttrs (
    map (
      spec:
      lib.nameValuePair "keyring_password_${spec.username}" {
        key = "keyring_password";
        owner = config.users.users.${spec.username}.name;
        mode = "0400";
        sopsFile = "${toString inputs.nix-secrets}/sops/shared.yaml";
      }
    ) users
  );

  systemd.user.services.gnome-keyring-autounlock = {
    description = "GNOME Keyring, unlocked from sops";

    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    before = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStartPost = chainOtherKeyrings;
    };
    path = [
      pkgs.gnome-keyring
      pkgs.procps
    ];
    script = ''
      PW_FILE=${pwFile}
      # greeter/root/service users have no secret, nothing to unlock
      [ -r "$PW_FILE" ] || exit 0

      # Own the secret service instead of talking to a daemon we did not start:
      # a D-Bus-activated or leftover daemon holds a locked login keyring, and
      # --unlock cannot reach it once its control socket is gone.
      pkill -u "$USER" -f gnome-keyring-daemon || true

      # gnome-keyring reads stdin verbatim, newline included - $() strips it.
      # Feed it via process substitution, not a pipe: `cmd | exec cmd2` forks
      # cmd2 into a subshell instead of replacing this process, so systemd's
      # MainPID would end up pointing at this script, not the real daemon -
      # ExecStartPost's rival-detection below compares against MainPID.
      PW="$(cat "$PW_FILE")"
      exec /run/wrappers/bin/gnome-keyring-daemon --foreground --unlock < <(printf %s "$PW")
    '';
  };
}
