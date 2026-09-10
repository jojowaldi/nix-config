{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [ inputs.custom-nixpkgs.hyprland.nixosModules.default ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;

    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.hypridle.enable = true;

  environment.pathsToLink = [
    "/share/hypr"
  ];

  environment.systemPackages = with pkgs; [
    kitty
  ];

  environment.sessionVariables = {
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      config.programs.hyprland.portalPackage
      xdg-desktop-portal-gtk
      hypr-kdeconnect-fix
    ];

    config = {
      Hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "hyprland"
        ];
        "org.freedesktop.impl.portal.Screenshot" = [
          "hyprland"
        ];
        "org.freedesktop.impl.portal.GlobalShortcuts" = [
          "hyprland"
        ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [
          "hypr-kdeconnect"
        ];
      };

      common = {
        default = [ "gtk" ];
      };
    };
  };
}
