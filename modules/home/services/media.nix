{ pkgs, ... }:

{
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.cosmic-files}/bin/cosmic-files";
      };
    };
  };

  systemd.user.services.deej = {
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
