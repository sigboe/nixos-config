#############################################################
#
#  Raspberry Pi4 travel NAS
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

      #################### Required Configs ####################
      ../common/core

      #################### Host-specific Optional Configs ####################
      (import ../common/optional/sops.nix { secretsFilename = "secrets"; inherit config lib inputs; })
      ../common/optional/laptop.nix #powersaving
      ../common/optional/docker.nix
      ../common/optional/qemu-kvm.nix

      ../common/users

      #################### Server ####################
      ../common/optional/services/plex.nix
      ../common/optional/services/hostapd.nix
    ];

  hostSpec = {
    hostName = "wakwak";
    inherit (inputs.nix-secrets.users.sigurdb)
      username
      description
      openssh
      ;
    inherit (inputs.nix-secrets.hosts.wakwak.services) hostapd;
  };

  boot = {
    kernelParams = [ "snd_bcm2835.enable_hdmi=1" "snd_bcm2835.enable_headphones=1" ];
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      systemd-boot.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
    lanzaboote.enable = false;
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="NO"
    '';
  };

  # Enable networking
  networking = {
    inherit (config.hostSpec) hostName;
    networkmanager = {
      enable = true;
      # Prevent host becoming unreachable on wifi after some time.
      wifi.powersave = false;
      unmanaged = [ "Interface-name:wlan0" ];
    };
    firewall = {
      allowedTCPPorts = [
        # 12315 # Grayjay Desktop
      ];
      allowedUDPPorts = [
        5182 # Wireguard
      ];
      #enable = false;
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

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

  # Change permissions gpio devices
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  # Add user to group
  users = {
    groups.gpio = { };
    users."${config.hostSpec.username}" = {
      extraGroups = [ "gpio" ];
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
