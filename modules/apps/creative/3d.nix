{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blender
    blockbench
  ];
}
