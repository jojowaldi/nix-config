{
  self,
  lib,
  hostSpec,
  ...
}:

{
  imports =
    with self.modules;
    [
      home.tools.virtualization

      home.coding.git
      home.coding.nvim

      home.cli.fastfetch
      home.cli.fish
      home.cli.gpg
      home.cli.shell
      home.cli.ssh
      home.cli.starship
      home.cli.zoxide
    ]
    # WSL: no GUI and no sops secrets
    ++ lib.optionals (!hostSpec.isWsl) [
      home.sops

      home.tools.terminal

      home.services.media

      home.hyprland.default

      home.gui.browser
      home.gui.theme

      home.coding.editor
    ];
}
