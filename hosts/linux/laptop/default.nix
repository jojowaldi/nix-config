{
  inputs,
  pkgs,
  self,
  ...
}:

{
  imports = with self.modules; [
    ./hardware-config.nix
    ../../spec.nix

    services.core.power
    services.gui.igpu
    services.media.miracast
    services.network.cloudflare

    ../../profiles/general.nix
    ../../profiles/system.nix
    ../../profiles/services.nix
    ../../profiles/apps.nix
  ];

  hostSpec = {
    hostname = "laptop";
    users = [
      inputs.nix-secrets.users.profidev
      {
        username = "root";
        secrets_user = "root";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    mcontrolcenter
  ];
}
