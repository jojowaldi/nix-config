{ hostSpec, ... }:

# only for macos because there is no nh in nix-darwin and only in home-manager
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1d --keep 10";
    clean.dates = "daily";
    flake = hostSpec.configPath;
  };
}