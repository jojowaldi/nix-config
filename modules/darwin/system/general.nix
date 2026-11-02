{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.primaryUser = (lib.head config.hostSpec.users).username;

  # scripts/rebuild.sh picks the flake host via `hostname`
  networking.hostName = config.hostSpec.hostname;
  networking.computerName = config.hostSpec.hostname;

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
}
