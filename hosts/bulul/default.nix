#############################################################
#
#  VM
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
      (import ../common/disks/luks-sops-btrfs-impermanence.nix { device = "/dev/vda"; })
      { disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/nix" = lib.mkForce { }; }
      (import ../common/disks/xfs-store.nix { device = "/dev/vdb"; })
      { disko.devices.disk.data.content.partitions.data.content.mountpoint = lib.mkForce "/nix"; }

      #################### Required Configs ####################
      ../common/core

      #################### Host-specific Optional Configs ####################

      ../common/optional/impermanence.nix
      (import ../common/optional/sops.nix { secretsFilename = "secrets"; inherit config lib inputs; })

      # Desktop
      # services
      ../common/optional/services/fwupd.nix
      ../common/optional/services/keyd.nix
      ../common/optional/services/remotebuilder-server.nix

      #################### Users to Create ####################
      ../common/users
    ];

  hostSpec = {
    hostName = "bulul";
    inherit (inputs.nix-secrets.users.sigurdb)
      username
      description
      openssh
      ;
    remoteBuild = {
      inherit (inputs.nix-secrets.remoteBuild) sshKey;
    };
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
  };

  # Enable hardware acceleration
  hardware.graphics.enable = true;

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

    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
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
