{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-utils
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
  ];
}
