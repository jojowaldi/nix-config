{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hidden-bar
    mas
  ];

  homebrew.casks = [
    "bitwarden"
    "obsidian"
    "stats"
    "vicinae"
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
        stats = "/Applications/Stats.app";
        hidden-bar = "/Applications/Nix Apps/Hidden Bar.app";
      };
}
