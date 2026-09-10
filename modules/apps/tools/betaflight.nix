{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    betaflight-configurator
  ];

  services.udev.extraRules = ''
    # DFU (Internal bootloader for STM32 and AT32 MCUs)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout"
  '';
}
