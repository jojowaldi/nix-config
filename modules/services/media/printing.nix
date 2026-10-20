{ pkgs, ... }:

{
  # Enable printing
  services.printing.enable = true;
  # splix lacks CLX-3180; Samsung ULD ships CLX-3180.ppd
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];
  environment.systemPackages = [ pkgs.cups-filters ];
}
