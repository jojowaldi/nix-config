{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alacritty-graphics
  ];

  programs.fish.enable = true;
  # Home manager completions are used instead
  programs.fish.generateCompletions = false;
}
