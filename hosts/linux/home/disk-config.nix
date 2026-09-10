{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../disks/btrfs.nix
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-CT1000P3PSSD8_233943C543A7";
        withSwap = true;
        swapSize = "32";
      };
    }
  ];
}
