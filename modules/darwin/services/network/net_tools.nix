{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    iperf3
  ];

  homebrew = {
    casks = [ "tailscale-app" ];
    masApps."WireGuard" = 1451685025;
  };
}
