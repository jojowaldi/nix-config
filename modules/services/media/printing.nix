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
  # eduroam floods mDNS, avahi spins at 100% CPU: stop it while connected there
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "avahi-eduroam" ''
        case "$2" in up | down) ;; *) exit 0 ;; esac
        if ${pkgs.networkmanager}/bin/nmcli -t -f NAME connection show --active | ${pkgs.gnugrep}/bin/grep -qx eduroam; then
          ${pkgs.systemd}/bin/systemctl stop avahi-daemon.socket avahi-daemon.service
        else
          ${pkgs.systemd}/bin/systemctl start avahi-daemon.socket avahi-daemon.service
        fi
      '';
    }
  ];

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
