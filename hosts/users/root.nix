{ self, ... }:

{
  imports = with self.modules; [
    home.cli.fastfetch
    home.cli.fish
    home.cli.shell
    home.cli.starship
    home.cli.zoxide
  ];
}
