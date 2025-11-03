# Install

## nixos-anywhere

Tip!: you need sops, age and ssh-to-age to do these steps. `nix-shell -p sops age ssh-to-age` if they are not installed locally

This section we primarily run on a non-live booted nix machine, either nixos or another distro with the nix package manager. The flake is too big to fit into memory when booting a live iso, haven't found a good workaround without making a minimal config to flash first. Instead we practically flash the whole config sans secureboot. 

0. Make config for new machine
  1. copy a folder in hosts, the machine that is the closest match
  2. folder name has to match host name
  3. boot live iso on the machine and `nixos-generate-config` copy this file to your main computer
  4. overwrite the generated hardware-configuration.nix in the new folder
  5. inside home/username copy the file of the closest host's file and rename it to the new hostname
1. Generate ssh host keys, add them to the sops repo as valid decryption keys
  1. `mkdir -p /tmp/sshKeys/persist/etc/ssh`
  2. `ssh-keygen -t rsa -b 4096 -f /tmp/sshKeys/persist/etc/ssh/ssh_host_rsa_key -N ''`
  3. `ssh-keygen -t ed25519 -f /tmp/sshKeys/persist/etc/ssh/ssh_host_ed25519_key -N ''`
  4. `ssh-to-age -i /tmp/sshKeys/persist/etc/ssh/ssh_host_ed25519_key.pub`
  5. add age key to nix-secrets/.sops.nix
  6. `sops updateKeys secrets.yaml` and push to git
  7. `nix flake update nix-secrets` git add, commmit, push
2. boot from target host with a live iso of the nixos installer
3. connect to network in the live environment on the target machine
4. set temporary password using `passwd`

```
nix run --extra-experimental-features 'nix-command flakes' "github:nix-community/nixos-anywhere" -- \
  --flake ".#hostname-bootstrap" \
  --disk-encryption-keys /tmp/secret.key <(sops --decrypt --extract '["luks-password"]' ~/git/nix-secrets/secrets.yaml) \
  --extra-files /tmp/sshKeys/ \
  nixos@192.168.122.176
```

## Post Install

This section is primarily done on the new machine. First we fetch down the flake, put it in the correct folder, if this is not the main computer git pull and sudo nixos-rebuild switch will be the command to update after. Then we make a root user ssh key, so sudo nixos-rebuild is able to fetch updates from nixos secrets repo. Then we set up secureboot. And finally we will setup automatic decription of the disk.

1. Make sure /etc/nixos is empty, then `sudo chown username:users /etc/nixos`
2. `git clone "https://github.com/sigboe/nixos-config.git" /etc/nixos` https is better for secondary machine, ssh is better for main machine. (git clone "git@github.com:sigboe/nixos-config.git")
3. generate an access key (ssh key) for nix-secrets as the root user `sudo ssh-keygen -t ed25519 -C "hostname"`
4. add the key to the nixos-secrets repo, settings, repository, deploy keys
5. time to set BIOS password, and boot into the mode that lets you provision secure boot keys your self.
6. `sudo sbctl create-keys`
7. `sudo nixos-rebuild switch` (this will switch us from the -bootstrap ghost config to the config that has lanzaboote)
8. `sudo sbctl enroll-keys --microsoft` This includes microsoft keys aswell, to avoid headaces
9. `sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 /dev/nvme0n1p2`
10. reboot now
