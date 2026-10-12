{ pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkDefault "suspend";
    HandleLidSwitchDocked = lib.mkDefault "ignore";
    HandleLidSwitchExternalPower = lib.mkDefault "suspend";
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
