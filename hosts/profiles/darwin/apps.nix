{ self, ... }:

{
  imports = with self.modules; [
    apps.nix

    darwin.apps.tools.cli
    darwin.apps.tools.gui

    darwin.apps.coding.cli_tools
    darwin.apps.coding.code_editor
    darwin.apps.coding.infra
    darwin.apps.coding.lang
    darwin.apps.coding.virt
  ];
}
