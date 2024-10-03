# Install

## nixos-anywhere

1. Generate ssh host keys, add them to the sops repo as valid decryption keys
  1. `mkdir /tmp/sshKeys`
  2. `ssh-keygen -t rsa -b 4096 -f /tmp/sshKeys/ssh_host_rsa_key -N ''`
  3. `ssh-keygen -t ed25519 -f /tmp/sshKeys/ssh_host_ed25519_key -N ''`
  4. `ssh-to-age -private-key -i /tmp/sshKeys/ssh_host_ed25519_key`
  5. add age key to nix-secrets/.sops.nix
  6. `sops updateKeys`
2. boot from iso
3. connect to network
4. set temporary password


```
nix run --extra-experimental-features 'nix-command flakes' "github:nix-community/nixos-anywhere" -- \
  --flake "github:sigboe/nixos-config#vm" \
  --disk-encryption-keys /tmp/secret.key <(sops --decrypt --extract '["luks-password"]' ~/git/nix-secrets/secrets.yaml) \
  --copy-host-keys /tmp/sshKeys/ssh_host_*
  nixos@192.168.122.176
```
