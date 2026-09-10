{ ... }:
{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.00000000000000000026b7686223c485";
        content = {
          type = "gpt";
          partitions = {
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@root" = {
                    mountpoint = "/mnt/media";
                    mountOptions = [
                      "defaults"
                      "subvol=root"
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
