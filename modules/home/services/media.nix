{
  pkgs,
  lib,
  hostSpec,
  ...
}:

{
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };

  services.easyeffects.enable = true;

  # deej mixer hardware only exists at the home desktop
  systemd.user.services.deej = lib.mkIf (hostSpec.hostname == "home") {
    Unit = {
      Description = "Deej Hardware Volume Mixer";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.deej}/bin/deej";
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
