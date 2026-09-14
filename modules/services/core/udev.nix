{ ... }:

{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2001", MODE="0666", TAG+="uaccess"
    
    KERNEL=="event*", SUBSYSTEM=="input", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2001", MODE="0666", TAG+="uaccess"
  '';
}
