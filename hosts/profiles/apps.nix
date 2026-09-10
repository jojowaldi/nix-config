{ self, ... }:

{
  imports = with self.modules; [
    apps.nix
    apps.libs

    apps.tools.cli
    apps.tools.gui
    apps.tools.media
    apps.tools.office
    apps.tools.proton
    apps.tools.terminal

    apps.gaming.steam
    apps.gaming.minecraft

    apps.creative.image
    apps.creative.video

    apps.coding.cli_tools
    apps.coding.code_editor
    apps.coding.docker
    apps.coding.gui_tools
    apps.coding.lang
  ];
}
