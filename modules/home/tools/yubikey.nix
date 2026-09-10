{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yubikey-manager
    yubioath-flutter
    yubikey-personalization
    yubioath-flutter
  ];
}
