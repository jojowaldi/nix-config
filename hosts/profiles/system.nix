{ self, ... }:

{
  imports = with self.modules; [
    system.boot
    system.firmware
    system.font
    system.general
    system.kernel
    system.locale
    system.sops
  ];
}
