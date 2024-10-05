# Install

## nixos-anywhere

Tip!: you need sops, age and ssh-to-age to do these steps. `nix-shell -p sops age ssh-to-age` if they are not installed locally

1. Generate ssh host keys, add them to the sops repo as valid decryption keys
  1. `mkdir -p /tmp/sshKeys/etc/ssh`
  2. `ssh-keygen -t rsa -b 4096 -f /tmp/sshKeys/etc/ssh/ssh_host_rsa_key -N ''`
  3. `ssh-keygen -t ed25519 -f /tmp/sshKeys/etc/ssh/ssh_host_ed25519_key -N ''`
  4. `ssh-to-age -i /tmp/sshKeys/etc/ssh/ssh_host_ed25519_key.pub`
  5. add age key to nix-secrets/.sops.nix
  6. `sops updateKeys secrets.yaml` and push to git
  7. `nix flake update nix-secrets` git add, commmit, push
2. boot from iso
3. connect to network
4. set temporary password


```
nix run --extra-experimental-features 'nix-command flakes' "github:nix-community/nixos-anywhere" -- \
  --flake "github:sigboe/nixos-config#vm" \
  --disk-encryption-keys /tmp/secret.key <(sops --decrypt --extract '["luks-password"]' ~/git/nix-secrets/secrets.yaml) \
  --extra-files /tmp/sshKeys/etc \
  nixos@192.168.122.176
```
