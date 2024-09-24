# Install
1. boot from iso
2. connect to nettwork
```
git checkout flake
cd into flake
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/vm/luks-btrfs-subvolumes.nix
sudo nixos-generate-config --root /mnt --no-filesystems --show-hardware-config > hosts/vm/hardware-configuration.nix
sudo nixos-install --flake .#vm --root /mnt
```
