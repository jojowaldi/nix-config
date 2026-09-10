{
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys.enable = true;
    autoEnrollKeys.autoReboot = true;

    configurationLimit = 8;
    measuredBoot = {
      pcrs = [
        0
        2
        3
        4
        7
      ];
    };
  };

  boot.plymouth.enable = true;

  boot.blacklistedKernelModules = [
    "ntfs3" # fast but always buggy
    "ntfs-3g" # slow but super reliable
  ];

  environment.systemPackages = with pkgs; [
    efibootmgr
    ntfsprogs-plus
    sbctl
  ];
}
