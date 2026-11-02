{ ... }:

{
  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;

    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    ApplePressAndHoldEnabled = false;

    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = true;

    AppleICUForce24HourTime = true;

    "com.apple.springing.enabled" = true;
    "com.apple.springing.delay" = 0.5;
    "com.apple.trackpad.forceClick" = true;
  };

  system.defaults.trackpad = {
    Clicking = false;
    TrackpadThreeFingerDrag = false;

    TrackpadRightClick = true;
    TrackpadCornerSecondaryClick = 0;
    TrackpadPinch = true;
    TrackpadRotate = true;
    TrackpadTwoFingerDoubleTapGesture = true;
    TrackpadThreeFingerTapGesture = 0;
    TrackpadMomentumScroll = true;

    TrackpadThreeFingerHorizSwipeGesture = 2;
    TrackpadThreeFingerVertSwipeGesture = 2;
    TrackpadFourFingerHorizSwipeGesture = 2;
    TrackpadFourFingerVertSwipeGesture = 2;
    TrackpadFourFingerPinchGesture = 2;
    TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;

    ActuateDetents = true;
    ForceSuppressed = false;
    FirstClickThreshold = 1;
    SecondClickThreshold = 1;
    Dragging = false;
    DragLock = false;
  };
}
