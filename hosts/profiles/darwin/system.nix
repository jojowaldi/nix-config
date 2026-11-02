{ self, ... }:

{
  imports = with self.modules; [
    system.font

    darwin.system.desktop
    darwin.system.dock
    darwin.system.finder
    darwin.system.general
    darwin.system.homebrew
    darwin.system.input
  ];
}
