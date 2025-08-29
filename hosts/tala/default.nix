#############################################################
#
#  Laptop
#
###############################################################
{ config
, inputs
, lib
, pkgs
, ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Disks
      (import ../common/disks/luks-sops-btrfs-impermanence.nix { device = "/dev/nvme0n1"; })

      #################### Hardware Modules ####################
      inputs.hardware.nixosModules.common-cpu-intel
      inputs.hardware.nixosModules.common-pc-ssd

      #################### Required Configs ####################
      ../common/core

      #################### Host-specific Optional Configs ####################

      ../common/optional/activationScripts.nix
      ../common/optional/impermanence.nix
      ../common/optional/plymouth.nix
      ../common/optional/steam.nix
      ../common/optional/packages-graphical.nix
      (import ../common/optional/sops.nix { secretsFilename = "secrets"; inherit config lib inputs; })
      (import ../common/optional/zen-browser.nix { isDefault = true; inherit config lib inputs pkgs; })

      # Desktop
      ../common/optional/services/regreet
      ../common/optional/sway.nix
      ../common/optional/services/pipewire.nix
      ../common/optional/3dprint.nix
      ../common/optional/vibe.nix
      # Laptop
      ../common/optional/laptop.nix
      # services
      ../common/optional/services/yubikey.nix
      ../common/optional/services/udisks.nix
      ../common/optional/services/fwupd.nix
      ../common/optional/services/keyd.nix
      ../common/optional/docker.nix
      ../common/optional/qemu-kvm.nix

      #################### Users to Create ####################
      ../common/users
    ];

  hostSpec = {
    hostName = "tala";
    inherit (inputs.nix-secrets.users.sigurdb)
      username
      description
      openssh
      ;
  };

  boot = {
    #kernelPackages =
    #  pkgs.linuxPackagesFor
    #    (pkgs.linux_6_12.override {
    #      argsOverride = rec {
    #        src = pkgs.fetchurl {
    #          url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    #          sha256 = "sha256-AZOx2G3TcuyJG655n22iDe7xb8GZ8wCApOqd6M7wxhk=";
    #        };
    #        version = "6.12.1";
    #        modDirVersion = "6.12.1";
    #      };
    #    });
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
    #  ipu6-drivers = super.ipu6-drivers.overrideAttrs (
    #    final: previous: rec {
    #      src = builtins.fetchGit {
    #        url = "https://github.com/intel/ipu6-drivers.git";
    #        ref = "master";
    #        rev = "b4ba63df5922150ec14ef7f202b3589896e0301a";
    #      };
    #      patches = [
    #        "${src}/patches/0001-v6.10-IPU6-headers-used-by-PSYS.patch"
    #      ];
    #    }
    #  );
    #});
    initrd = {
      kernelModules = [ "btintel" ];
      availableKernelModules = [ "tpm_tis" ];
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
    };
    bootspec.enable = true;
  };

  # Enable hardware acceleration
  hardware.graphics.enable = true;

  ## webcam
  #hardware.ipu6 = {
  #  enable = true;
  #  platform = "ipu6ep"; #Alder Lake
  #};

  # Enable networking
  networking = {
    inherit (config.hostSpec) hostName;
    networkmanager.enable = true;
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    firewall = {
      allowedTCPPorts = [
        12315 # Grayjay Desktop
      ];
      allowedUDPPorts = [
        5182 # Wireguard
      ];
      #enable = false;
    };
  };

  security = {
    polkit.enable = true;
    tpm2.enable = true;
  };

  services = {
    # Ignore accidental powerkey press
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.shells = with pkgs; [ zsh ];

  home-manager = {
    useGlobalPkgs = true;
  };

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
      sha256 = "7e6285630da06006058cebf896bf089173ed65f135fbcf32290e2f8c471ac75b";
    };
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    autoEnable = true;
    targets = {
      plymouth.enable = false;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
