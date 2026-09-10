{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    drawio
    gimp
  ];
}
