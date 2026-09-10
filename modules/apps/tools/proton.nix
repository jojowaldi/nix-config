{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonmail-desktop
    proton-vpn
    proton-pass
  ];
}
