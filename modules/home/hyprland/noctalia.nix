{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    inputs.custom-nixpkgs.noctalia.homeModules.default
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
      name = lib.mkForce "adw-gtk3";
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
    GTK_THEME = "adw-gtk3";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3";
      color-scheme = "prefer-dark";
    };
  };

  services.hyprpolkitagent.enable = lib.mkForce false;
  services.kdeconnect.enable = true;

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../../assets/hyprland/noctalia.lua;



  programs.noctalia = {
    enable = true;
    package = pkgs.noctalia;
    systemd.enable = true;

    settings =
      lib.recursiveUpdate (fromTOML (builtins.readFile ../../../assets/shells/noctalia-settings.toml))
        {
          shell = {
            avatar_path = ../../../assets/images/profilepicture.png;
          };
        };
  };

  home.activation = {
    deleteOldNoctaliaSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rm -f "$HOME/.local/state/noctalia/settings.toml"
    '';
  };
}
