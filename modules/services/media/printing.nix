{ pkgs, ... }:

{
  # Enable printing
  services.printing.enable = true;
  environment.systemPackages = [ pkgs.cups-filters ];
}
