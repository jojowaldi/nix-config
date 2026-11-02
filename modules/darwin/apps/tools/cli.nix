{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    eza
    tree
    just
    yq-go
    ripgrep
  ];
}
