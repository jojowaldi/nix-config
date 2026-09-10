{ lib, pkgs, ... }:

{
  security.pam.services = {
    login.u2fAuth = true;
    login.fprintAuth = true;
    login.rules.auth.fprintd.settings.timeout = 99;
    gdm-password.u2fAuth = true;
    gdm-password.enableGnomeKeyring = true;
    sddm.u2fAuth = true;
    sddm.fprintAuth = true;
    sddm-greeter.u2fAuth = true;
    sddm-greeter.fprintAuth = true;
    sudo.u2fAuth = true;
    sudo.fprintAuth = true;
    polkit-1.fprintAuth = true;
    polkit-1.u2fAuth = true;
  };

  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };

  services.pcscd.enable = true;

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (
        (action.id == "org.freedesktop.login1.reboot" ||
         action.id == "org.freedesktop.login1.power-off" ||
         action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
         action.id == "org.freedesktop.login1.power-off-multiple-sessions") &&
        (subject.user == "ha_power")
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  users.users.ha_power = {
    isNormalUser = true;
    createHome = lib.mkForce false;
    group = "ha_power";
    home = "/var/empty";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFTMajOlMBaHKWMnYsSyHRO0gC2BczCsIhlzwH3EFdP root@a0d7b954-ssh"
    ];
  };

  users.groups.ha_power = { };

  security.sudo.extraRules = [
    # Allow execution of cosmic-randr as sddm by ha_power without sudo password
    {
      users = [ "ha_power" ];
      runAs = "sddm,profidev";
      commands = [
        {
          command = "/run/current-system/sw/bin/cosmic-randr";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
    # Allow execution of wlr-randr as sddm by ha_power without sudo password
    {
      users = [ "ha_power" ];
      runAs = "sddm,profidev";
      commands = [
        {
          command = "/run/current-system/sw/bin/wlr-randr";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
    # Allow execution of wlopm as sddm by ha_power without sudo password
    {
      users = [ "ha_power" ];
      runAs = "sddm,profidev";
      commands = [
        {
          command = "/run/current-system/sw/bin/wlopm";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    wlopm
  ];
  /*
    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';
  */
}
