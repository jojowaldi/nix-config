{ pkgs, ... }:

{
  # Host side: stream this machine to Moonlight clients
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # KMS capture on Wayland
  };

  # Only reachable via Tailscale, not on LAN/public interfaces
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [
      47984
      47989
      47990
      48010
    ];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
    ];
  };

  # Client side: connect to the other machine
  environment.systemPackages = [ pkgs.moonlight-qt ];
}
