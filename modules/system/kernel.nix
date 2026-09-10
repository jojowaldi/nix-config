{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchDocked = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
  };

  boot = {
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      systemd.enable = true;
      systemd.tpm2.enable = true;
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
