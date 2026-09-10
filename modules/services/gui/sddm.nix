{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.silentSDDM.nixosModules.default
  ];

  programs.silentSDDM = {
    enable = true;
    theme = "default";

    settings = {
      LockScreen = {
        display = false;
      };
      LoginScreen = {
        use-background-color = true;
        background-color = "#000000";
      };
      "LoginScreen.MenuArea.Layout" = {
        display = false;
      };
      "LoginScreen.MenuArea.Keyboard" = {
        display = false;
      };
    };

    profileIcons = {
      profidev = ../../../assets/images/profidev.jpeg;
    };
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = lib.mkForce true;
    wayland.compositor = lib.mkForce "kwin";

    enableHidpi = true;
    extraPackages = with pkgs; [
      bibata-cursors
    ];
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };
  };

  environment.variables = {
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };

  home-manager.users.sddm = {
    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      bibata-cursors
    ];
  };
}
