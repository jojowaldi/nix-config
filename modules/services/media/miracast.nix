{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnome-network-displays
  ];

  networking.firewall = {
    allowedUDPPorts = [
      7236
      5353
    ];
    allowedTCPPorts = [
      7236
      7250
    ];
  };
}
