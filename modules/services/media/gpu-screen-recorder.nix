{
  pkgs,
  config,
  lib,
  ...
}:

let
  uiPackage = pkgs.gpu-screen-recorder-ui.override {
    gpu-screen-recorder = pkgs.gpu-screen-recorder;
    inherit (config.security) wrapperDir;
  };
in
{
  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
    gpu-screen-recorder-ui
    gpu-screen-recorder-notification
  ];

  security.wrappers."gsr-global-hotkeys" = {
    owner = "root";
    group = "root";
    capabilities = "cap_setuid+ep";
    source = lib.getExe' uiPackage "gsr-global-hotkeys";
  };

  environment.etc."xdg/autostart/gpu-screen-recorder.desktop" = {
    source = "${pkgs.gpu-screen-recorder-ui}/share/applications/gpu-screen-recorder.desktop";
  };
}
