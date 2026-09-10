{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs.positron.packages.${stdenv.hostPlatform.system}.default
  ];

  systemd.user.services.positron = {
    Unit = {
      Description = "Positron";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = with pkgs; {
      ExecStart = "${inputs.positron.packages.${stdenv.hostPlatform.system}.default}/bin/positron";
      Restart = "always";
      RestartSec = 5;
    };
  };

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../../assets/hyprland/positron.lua;
}
