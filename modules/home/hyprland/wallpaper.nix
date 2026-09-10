{ pkgs, ... }:

let
  script = pkgs.writeScriptBin "wallpaper.sh" ''
    #!/usr/bin/env bash
    set -e
    pwd=$(pwd)

    wget https://profidev.io/api/services/apod/random -O wallpaper.png

    awww img $pwd/wallpaper.png --transition-type fade --transition-duration 0 --resize crop
  '';
in
{
  systemd.user.services.auto-wallpaper = {
    Unit = {
      Type = "simple";
      Description = "Auto Wallpaper Changer";
    };

    Service = {
      ExecStart = "${script}/bin/wallpaper.sh";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  services.awww.enable = true;
}
