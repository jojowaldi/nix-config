{ pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  environment.systemPackages = with pkgs; [
    wlr-randr
  ];

  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
