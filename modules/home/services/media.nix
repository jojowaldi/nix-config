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
}
