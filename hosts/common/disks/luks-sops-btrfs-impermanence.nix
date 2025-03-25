{ device ? throw "example /dev/nvme0n1", ... }: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              # nixos-anywhere --disk-encryption-keys <remoth_path> <local_path>
              passwordFile = "/tmp/secret.key";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/snapshots" = {
                    mountpoint = "/snapshots";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=12G" "defaults" "mode=755" ];
    };
  };
  services.btrbk = {
    instances."home" = {
      onCalendar = "daily";
      settings = {
        snapshot_preserve = "7d 4w 12m";
        snapshot_preserve_min = "7d";
        volume = {
          "/home" = {
            snapshot_dir = "/snapshots";
            subvolume = "/home";
          };
          "/persist" = {
            snapshot_dir = "/snapshots";
            subvolume = "/persist";
            snapshot_create = "onchange";
          };
        };
      };
    };
  };
}
