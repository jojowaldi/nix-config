{ config, ... }:

{
  system.defaults.dock = {
    autohide = false;
    orientation = "right";
    tilesize = 27;
    largesize = 70;
    magnification = true;
    launchanim = false;
    mineffect = "genie";
    mru-spaces = false;
    show-recents = false;
    show-process-indicators = true;

    wvous-br-corner = 14;

    persistent-apps = [
      "/System/Applications/Apps.app"
      "/System/Applications/Messages.app"
      "/Applications/Zen.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Music.app"
      "/System/Applications/System Settings.app"
    ];

    persistent-others = [ "/Users/${config.system.primaryUser}/Downloads" ];
  };
}
