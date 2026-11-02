{
  lib,
  self,
  isLinux,
  ...
}:

{
  imports =
    with self.modules;
    [
      home.sops

      home.tools.terminal

      home.coding.editor
      home.coding.git
      home.coding.nvim

      home.cli.fastfetch
      home.cli.fish
      home.cli.shell
      home.cli.ssh
      home.cli.starship
      home.cli.zoxide
    ]
    ++ lib.optionals isLinux [
      home.tools.virtualization

      home.services.media

      home.hyprland.default

      home.gui.browser
      home.gui.theme

      home.cli.gpg
    ]
    ++ lib.optionals (!isLinux) [
      home.nix
    ];
}
