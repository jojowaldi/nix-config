{ pkgs, ... }:

let
  start = pkgs.writeShellScript "wayvnc-start" ''
    dir="$HOME/.config/wayvnc"
    mkdir -p "$dir"
    # RSA-AES key for encryption; login is the normal user password via PAM
    [ -f "$dir/rsa_key.pem" ] || ${pkgs.openssh}/bin/ssh-keygen -q -m pem -t rsa -N "" -f "$dir/rsa_key.pem"
    cat > "$dir/config" <<EOF
    address=0.0.0.0
    port=5900
    enable_auth=true
    enable_pam=true
    rsa_private_key_file=$dir/rsa_key.pem
    EOF
    exec ${pkgs.wayvnc}/bin/wayvnc --config="$dir/config"
  '';
in
{
  # Host side: share the running Hyprland session via VNC (connect with tigervnc's vncviewer)
  security.pam.services.wayvnc = { };

  systemd.user.services.wayvnc = {
    description = "wayvnc VNC server";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = start;
      Restart = "always";
      RestartSec = 5;
    };
  };

  # Only reachable via Tailscale, not on LAN/public interfaces
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5900 ];
}
