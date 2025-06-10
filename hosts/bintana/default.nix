#############################################################
#
#  WSL
#
###############################################################
{ config
, pkgs
, lib
, ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      #################### Required Configs ####################
      ../common/core

      #################### Host-specific Optional Configs ####################

      ../common/optional/services/pipewire.nix
      ../common/optional/docker.nix
      ../common/optional/qemu-kvm.nix
      (import ../common/optional/ollama.nix { acceleration = "cuda"; })

      #################### Users to Create ####################
      ../common/users/minimal.nix
    ];

  hostSpec = {
    hostName = "bintana";
    username = "sigurdb";
  };

  wsl = {
    enable = true;
    defaultUser = config.hostSpec.username;
  };
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote.enable = lib.mkForce false;
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
  };

  services = {
    gnome.gnome-keyring.enable = true;
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
