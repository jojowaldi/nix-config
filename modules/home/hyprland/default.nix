{
  hostSpec,
  lib,
  pkgs,
  ...
}:

let
  base = builtins.readFile ../../../assets/hyprland/config.lua;
  io = builtins.readFile ../../../assets/hyprland/io.lua;
  keybinds = builtins.readFile ../../../assets/hyprland/keybinds.lua;
  layers = builtins.readFile ../../../assets/hyprland/layers.lua;
  style = builtins.readFile ../../../assets/hyprland/style.lua;

  highDpiFix = (
    lib.optionalString hostSpec.hyprlandHiDpiFix ''
      hl.config({
          xwayland = {
              force_zero_scaling = true;
          };
      })
    ''
  );
in
{
  imports = [
    ./noctalia-legacy.nix
    #./noctalia.nix
    ./vicinae.nix
    ./wallpaper.nix
    ./positron.nix
  ];

  home.packages = with pkgs; [
    hyprpicker
    wtype
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    systemd.enable = false;
    package = null;
    portalPackage = null;

    extraConfig = builtins.concatStringsSep "\n" [
      base
      hostSpec.hyprlandMonitorConfig
      io
      keybinds
      layers
      style
      highDpiFix
    ];
  };

  services.hyprpolkitagent.enable = true;
}
