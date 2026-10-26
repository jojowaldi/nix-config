{ pkgs, ... }:

{
  # Enable printing
  services.printing.enable = true;
  # splix lacks CLX-3180; Samsung ULD ships CLX-3180.ppd
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];
  environment.systemPackages = [ pkgs.cups-filters ];

  # mDNS discovery of network printers/scanners
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  hardware.sane.enable = true;
  # xerox_mfp has no network discovery, so the CLX-3180 needs its IP;
  # replaces the default xerox_mfp.conf (drops its USB ids)
  hardware.sane.extraBackends = [
    (pkgs.writeTextDir "etc/sane.d/xerox_mfp.conf" "tcp 192.168.178.119\n")
  ];
  hardware.sane.brscan4 = {
    enable = true;
    netDevices.brother = {
      model = "MFC-L2700DW";
      ip = "192.168.178.62";
    };
  };
}
