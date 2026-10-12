{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    cinny-desktop
    karere
    teamspeak6-client
    spotify
  ];
}
