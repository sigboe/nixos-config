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

      # Desktop
      ../common/optional/services/regreet
      ../common/optional/sway.nix
      ../common/optional/services/pipewire.nix
      ../common/optional/3dprint.nix
      ../common/optional/card-forge.nix
      # Laptop
      ../common/optional/laptop.nix
      # services
      ../common/optional/services/yubikey.nix
      ../common/optional/services/udisks.nix
      ../common/optional/services/fwupd.nix
      ../common/optional/services/keyd.nix
      ../common/optional/docker.nix
      ../common/optional/qemu-kvm.nix
      ../common/optional/services/winboat.nix

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
    kernelPackages = pkgs.linuxPackages_latest;
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

  specialisation = {
    lts.configuration = {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
    };
  };

  # Enable hardware acceleration
  hardware.graphics.enable = true;

  ## webcam
  #hardware.ipu6 = {
  #  enable = true;
  #  platform = "ipu6ep"; #Alder Lake
  #};
  hardware.firmware = with pkgs; [
    ipu6-camera-bins
    ivsc-firmware
  ];
  services.udev.extraRules = ''
    SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
  '';
  boot.extraModulePackages = with config.boot.kernelPackages; [ ipu6-drivers ];

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
