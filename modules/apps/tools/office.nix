{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    texliveFull
    tex-fmt
    beamerpresenter
    wayscriber
    wayscriber-configurator
  ];
}
