{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../disks/btrfs-luks.nix
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-INTENSO_SSD_1642408002002208";
        withSwap = true;
        swapSize = "32";
      };
    }
  ];
}
