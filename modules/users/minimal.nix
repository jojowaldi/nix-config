{ config, lib, ... }:

{
  # Create ssh sockets directory for controlpaths when homemanager not loaded (i.e. isMinimal)
  systemd.tmpfiles.rules = lib.lists.flatten (
    map (
      spec:
      let
        user = config.users.users.${spec.username}.name;
        group = config.users.users.${spec.username}.group;
        # you must set the rule for .ssh separately first, otherwise it will be automatically created as root:root and .ssh/sockects will fail
      in
      [
        "d /home/${spec.username}/.ssh 0750 ${user} ${group} -"
        "d /home/${spec.username}/.ssh/sockets 0750 ${user} ${group} -"
      ]
    ) config.hostSpec.users
  );
}
