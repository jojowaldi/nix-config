{ pkgs, ... }:

{
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
  };

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    protontricks.enable = true;
  };
}
