{ pkgs, ... }:

{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  environment.systemPackages = with pkgs; [
    btrfs-assistant
  ];
}
