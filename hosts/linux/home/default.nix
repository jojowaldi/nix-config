{ inputs, self, ... }:

{
  imports = with self.modules; [
    ./hardware-config.nix
    ../../spec.nix

    system.no-sleep

    services.gui.nvidia
    services.gui.flatpak
    services.core.cooling
    services.network.nix-serve
    services.media.gpu-screen-recorder
    services.media.jellyfin
    services.media.ollama
    services.coding.virtualization

    apps.coding.gamedev
    apps.coding.graphics_coding
    apps.creative."3d"
    apps.creative."3d_print"
    apps.gaming.games
    apps.tools.betaflight
    apps.tools.profiling

    ../../profiles/general.nix
    ../../profiles/system.nix
    ../../profiles/services.nix
    ../../profiles/apps.nix
  ];

  hostSpec = {
    hostname = "home";
    users = [
      inputs.nix-secrets.users.profidev
      {
        username = "root";
        secrets_user = "root";
      }
    ];
  };
}
