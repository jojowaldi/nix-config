{ config, ... }:

let
  users = config.hostSpec.users;
in
{
  services.tailscale = {
    enable = true;
    extraSetFlags = [
      "--operator=${(builtins.elemAt users 0).username}"
    ];
  };

  systemd.services.tailscaled.serviceConfig.Type = "simple";
}
