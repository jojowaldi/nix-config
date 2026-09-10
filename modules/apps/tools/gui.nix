{
  pkgs,
  isLinux,
  lib,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    [
      filezilla
      piper
      xkill
      zathura
      rpi-imager
    ]
    ++ lib.optionals isLinux [
      wl-clipboard
      claude-desktop
    ];

  services = (
    if isLinux then
      {
        ratbagd.enable = true;
      }
    else
      { }
  );

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
