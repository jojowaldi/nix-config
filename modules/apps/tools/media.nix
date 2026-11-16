{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    karere
    teamspeak6-client
    spotify
  ];
}
