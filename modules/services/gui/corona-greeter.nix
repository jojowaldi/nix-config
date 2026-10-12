{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.custom-nixpkgs.corona.nixosModules.greeter
  ];

  systemd.services.plymouth-quit.wantedBy = lib.mkForce [ ];

  security.pam.services.greetd = {
    enable = true;
    fprintAuth = true;
    u2fAuth = true;
  };

  services.corona-greeter = {
    enable = true;

    keyboard.layout = "de";

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    profileIcons = {
      jojowaldi = ../../../assets/images/profilepicture.png;
    };
  };
}
