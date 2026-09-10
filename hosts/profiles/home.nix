{ self, ... }:

{
  imports = with self.modules; [
    home.sops

    home.tools.terminal
    home.tools.yubikey
    home.tools.virtualization

    home.services.media

    home.hyprland.default

    home.gui.browser
    home.gui.theme

    home.coding.editor
    home.coding.git
    home.coding.nvim

    home.cli.fastfetch
    home.cli.fish
    home.cli.gpg
    home.cli.shell
    home.cli.ssh
    home.cli.starship
    home.cli.zoxide
  ];
}
