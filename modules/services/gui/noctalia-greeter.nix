{ inputs, pkgs, ... }:

{
  imports = [
    inputs.custom-nixpkgs.noctalia-greeter.nixosModules.default
  ];

  programs.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
      keyboard = {
        layout = "de";
        numlock = true;
      };
    };
  };
}
