{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    corona
    nautilus
    kdePackages.qttools
    ddcutil
    wireguard-tools
  ];

  imports = [
    ./hyprland.nix
  ];

  environment.pathsToLink = [ "/share/corona" ];

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" ];

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
  security.pam.services.corona.fprintAuth = lib.mkDefault false;

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gnome.evolution-data-server.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };
}
