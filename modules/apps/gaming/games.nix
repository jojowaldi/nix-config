{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    heroic
    #r2modman
    wine
    winetricks
    gamemode

    inputs.proton.packages.${stdenv.hostPlatform.system}.default
  ];
}
