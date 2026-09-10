{
  lib,
  modulesPath,
  config,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ata_piix"
    "ohci_pci"
    "ehci_pci"
    "nvme"
    "usbhid"
    "ahci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "msi-ec"
    "ec-sys"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    msi-ec
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/1e6ed03a-1bc4-4199-993f-8c23e5d9a0dd";
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "acpi_sleep=nonvs"
    "resume_offset=533760"
  ];
  hardware.cpu.intel.updateMicrocode = true;
  boot.lanzaboote.measuredBoot.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hostSpec.hyprlandMonitorConfig = builtins.readFile ./monitors.lua;

  hostSpec.hyprlandHiDpiFix = true;
}
