<div align="center">
<h1>
<img width="100" src="docs/nixos-logo.png" /> <br>
</h1>
</div>

# Ziggurat's Nixos Configuration

## Table of Contents

- [Feature Highlights](#feature-highlights)
- [TODO](#todo)
- [Hosts](#hosts)
- [Secrets Management](#secrets-management)
- [Initial Install Notes](docs/Install.md)
- [Acknowledgements](#acknowledgements)

---

## Feature Highlights

- Flake-based multi-host, multi-user NixOS and Home-Manager configurations
  - Core configs for hosts and users
  - Modular, optional configs for user and host-specific needs
- Secrets management via sops-nix and a _private_ nix-secrets repo which is included as a flake input
- Semi automated remote-bootstrapping of NixOS, nix-config
- Configuration features:
  - Disko for delclarative 
  - Impermanence, root on tmpfs
  - Sops makes it so I don't need to store encrypted or hashed user passwords in a public repo
  - Neovim, via nixvim, with treesitter, lsp and completion, etc
  - nix-index-database, and Comma (Run programs without installing using executable name not package name)
  - Stylix applies Catppuccin Mocha everywhere* (most places)
  - greetd as the display manager, with regreet for the authentication UI
  - custom packages
  - Activation Scripts:
    - Git commit (not push) after every successful rebuild switch (not during boot) with a useful comment
    - ensure directories in users home is present
  - Everything I did using ansible on my previous Arch install (Bluetooth, Avahi etc)
  - Laptop support using tlp, thermald and more
  - Steam with gamescope, proton-ge, remote play, font fixes, etc

## TODO

- ~~Fix overlays~~
- ~~Look into bootstrapping without sops workaround~~ (untested solution in place)

## Hosts

Not all hosts are yet migrated to NixOS, but names are reserved. 
Names are based on pre-colonial Filipino mythology 🇵🇭

| **Machine**  | **Name** |
|--------------|----------|
| XPS 13       | Tala     |
| Gaming PC    | Lalahon  |
| HP EliteDesk | Kaptan   |
| Home Server  | Bathala  |
|              |          |
| HP EliteBook | Amihan   |
| Gaming PC    | Haliya   |

## Secrets Managment

## Initial Install Notes

Currently there is an issue with using sops during provisioning. A computer with nix or nixos is required currently. These are basic instructions for my self, if you copy this whole setup you need to do more changes. More detailed, but in progress instructions [here](docs/Install.md)

- Pull down the repo, and change the user password temporarily
- Pull down secrets repo to get luks key
- have ssh keys available for the secrets repo
- use nixos anywhere to provision locally changed flake (magic incantation will be in the full install notes)
- after install, pull down flake repo, put in /etc/nixos 
- transfer ssh priv keys, pull down secrets repo, add new age keys to secrets repo
- update /etc/nixos to fetch the newest version of secrets repo
- rebuild switch

## Acknowledgements

- [EmergentMind](https://github.com/emergentmind) - Stole the flake structure and some files wholesale
- [VimJoyer](https://github.com/vimjoyer) - For making several amazing videos, most importantly [The Ultimate Nix Flakes Guide](https://www.youtube.com/watch?v=JCeYq72Sko0)
- [Mathias](https://github.com/Mathsterk/) - For letting me pretend that everyone at work were supposed to switch to nixos
- My son - For giving me paternal leave

