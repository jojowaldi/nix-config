{ ... }:

{
  security.pam.services.sudo_local.touchIdAuth = true;

  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  system.defaults.loginwindow.DisableConsoleAccess = true;

  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
}
