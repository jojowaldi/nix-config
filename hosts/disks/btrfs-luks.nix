# NOTE: ... is needed because dikso passes diskoFile
{
  lib,
  pkgs,
  disk ? "/dev/vda",
  withSwap ? false,
  swapSize,
  ...
}:
{
  disko.devices = {
    disk = {
      disk0 = {
        type = "disk";
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "encrypted-nixos";
                passwordFile = "/tmp/disko-password"; # this is populated by bootstrap-nixos.sh
                settings = {
                  allowDiscards = true;
                  # https://github.com/hmajid2301/dotfiles/blob/a0b511c79b11d9b4afe2a5e2b7eedb2af23e288f/systems/x86_64-linux/framework/disks.nix#L36
                  crypttabExtraOpts = [
                    "token-timeout=30s"
                    "x-systemd.device-timeout=30s"
                    "tpm2-device=auto"
                    "tpm2-measure-pcr=yes"
                  ];
                };
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # force overwrite
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "defaults"
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "defaults"
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "defaults"
                        "subvol=root"
                        "compress=zstd"
                        "noatime"
                        "space_cache=v2"
                        "discard=async"
                      ];
                    };
                    "@swap" = lib.mkIf withSwap {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "${swapSize}G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  environment.systemPackages = [
    pkgs.yubikey-manager # For luks fido2 enrollment before full install
  ];
}
