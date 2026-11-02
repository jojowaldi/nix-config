{ config, inputs, ... }:

{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  homebrew = {
    enable = true;
    global.brewfile = true;

    taps = builtins.attrNames config.nix-homebrew.taps;

    onActivation = {
      autoUpdate = true;
      upgrade = true;

      # uninstalls every brew/cask/mas app that is not declared here
      cleanup = "zap";
    };
  };
}
