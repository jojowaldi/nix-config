{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    noctalia-shell
    cosmic-files
    kdePackages.qttools
  ];

  imports = [
    ./hyprland.nix
  ];

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  services.hypridle.enable = lib.mkForce false;

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gnome.evolution-data-server.enable = true;
}
