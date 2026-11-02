{ ... }:

{
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    NSTableViewDefaultSizeMode = 2;
  };

  system.defaults.menuExtraClock = {
    IsAnalog = true;
    ShowDayOfWeek = true;
    ShowAMPM = true;
    ShowDate = 0;
  };

  system.defaults.controlcenter = {
    BatteryShowPercentage = false;
  };

  system.defaults.screencapture = {
    type = "png";
    disable-shadow = true;
  };

  system.defaults.loginwindow = {
    GuestEnabled = false;
    SHOWFULLNAME = true;
  };

  system.defaults.WindowManager = {
    EnableStandardClickToShowDesktop = false;
    GloballyEnabled = false;
    AutoHide = false;
    HideDesktop = true;
    StageManagerHideWidgets = false;
    StandardHideWidgets = false;
    AppWindowGroupingBehavior = true;
    EnableTiledWindowMargins = false;
  };

  system.defaults.CustomUserPreferences.NSGlobalDomain = {
    AppleIconAppearanceTheme = "RegularDark";
    AppleMiniaturizeOnDoubleClick = false;
  };
}
