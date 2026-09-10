{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../disks/btrfs-luks.nix
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-eui.6479a7b36ad0045f";
        withSwap = true;
        swapSize = "32";
      };
    }
  ];
}
