{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #texliveFull
    #tex-fmt
    beamerpresenter
  ];
}
