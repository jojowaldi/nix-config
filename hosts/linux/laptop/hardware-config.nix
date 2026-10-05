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
    "usb_storage"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "kvm-amd"
    "ec-sys"
  ];
  boot.resumeDevice = "/dev/disk/by-id/nvme-INTENSO_SSD_1642408002002208";
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "acpi_sleep=nonvs"
    "resume_offset=23911646"
    "resume=/dev/disk/by-id/nvme-INTENSO_SSD_1642408002002208"
  ];
  hardware.cpu.amd.updateMicrocode = true;

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
