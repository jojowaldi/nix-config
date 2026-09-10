{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../disks/btrfs.nix
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-eui.0025384b3140a47d";
        withSwap = true;
        swapSize = "32";
      };
    }
    ./media-disk.nix
  ];
}
