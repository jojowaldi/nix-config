{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    blockbench
    webots
  ];

  environment.pathsToLink = [ "/share/webots" ];
}
