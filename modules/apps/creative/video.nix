{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obs-studio
    kdePackages.kdenlive
    vlc
  ];
}
