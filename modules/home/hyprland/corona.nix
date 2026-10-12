{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.custom-nixpkgs.corona.homeModules.default
  ];

  home.packages = with pkgs; [
    adw-gtk3
    nwg-look
    glib
    sshfs
  ];

  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "adw-gtk3-dark";
      package = lib.mkForce pkgs.adw-gtk3;
    };
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3-dark";
      color-scheme = "prefer-dark";
    };
  };

  services.hyprpolkitagent.enable = lib.mkForce false;
  services.kdeconnect.enable = true;

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../../assets/hyprland/corona.lua;

  programs.corona = {
    enable = true;

    settings =
      lib.recursiveUpdate (fromTOML (builtins.readFile ../../../assets/shells/corona-settings.toml))
        {
          shell = {
            avatar = ../../../assets/images/profilepicture.png;
          };
        };
  };

  home.activation = {
    deleteOldCoronaSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -f "$HOME/.local/state/corona/settings.toml"
    '';
  };
}
