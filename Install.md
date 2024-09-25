# Install
1. boot from iso
2. connect to nettwork
```
git checkout flake
cd into flake
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/vm/luks-btrfs-subvolumes.nix
sudo nixos-generate-config --root /mnt --no-filesystems --show-hardware-config > hosts/vm/hardware-configuration.nix
sudo nixos-install --max-jobs 16 --flake github:sigboe/nixos-config#vm --root /mnt
```

The following doesn't work, but maybe I should open an issue on disko and ask why
```
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --write-efi-boot-entries --flake 'github:sigboe/nixos-conf#vm' --disk main /dev/vda --mode format
```
