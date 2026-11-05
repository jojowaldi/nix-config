{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hidden-bar
    mas
  ];

  homebrew.casks = [
    "aldente"
    "bitwarden"
    "creality-print"
    "google-chrome"
    "obsidian"
    "vicinae"
    "vorssaint"
    "zen"
  ];

  launchd.user.agents =
    lib.mapAttrs
      (_: app: {
        serviceConfig = {
          ProgramArguments = [
            "/usr/bin/open"
            "-a"
            app
          ];
          RunAtLoad = true;
        };
      })
      {
        vicinae = "/Applications/Vicinae.app";
        vorssaint = "/Applications/Vorssaint.app";
        hidden-bar = "/Applications/Nix Apps/Hidden Bar.app";
      };
}
