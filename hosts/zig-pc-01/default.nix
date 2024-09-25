#############################################################
#
#  Desktop
#
###############################################################
{ inputs
, pkgs
, ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      #################### Hardware Modules ####################
      inputs.hardware.nixosModules.common-cpu-amd
      inputs.hardware.nixosModules.common-gpu-amd
      inputs.hardware.nixosModules.common-pc-ssd
      #################### Required Configs ####################
      ../common/core

      #################### Host-specific Optional Configs ####################

      ../common/optional/plymouth.nix
      ../common/optional/steam.nix
      ../common/optional/qemu-kvm.nix

      # Desktop
      ../common/optional/services/greetd
      ../common/optional/sway.nix
      ../common/optional/services/pipewire.nix
      # services
      ../common/optional/services/yubikey.nix

      #################### Users to Create ####################
      ../common/users/sigurdb
    ];

  # Enable bluetooth
  boot.initrd.kernelModules = [ "btintel" ];

  # Enable hardware acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable networking
  networking = {
    hostName = "zig-pc-01"; # Define your hostname.
    networkmanager.enable = true;
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    firewall = {
      #allowedTCPPorts = [22];
      #allowedUDPPorts = [ ... ];
      #enable = false;
    };
  };

  # Ignore accidental powerkey press
  services.logind = {
    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
  };

  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    SDL2
    acpi
    alejandra
    ansible-language-server
    ansible-lint
    base16-schemes
    bat
    bind
    bluez
    btop
    chromium
    comma
    cups
    eza
    fd
    firefox
    freetype
    furmark
    fzf
    gamescope
    gcc
    git
    github-cli
    gnutls
    go
    home-manager
    htop
    imagemagick
    jq
    kanshi
    kitty
    lazygit
    libgpgerror
    libxml2
    lutris
    mangohud
    mpd
    mpv
    ncdu
    nodejs_22
    networkmanagerapplet
    openldap
    p7zip
    pass
    pavucontrol
    pciutils
    playerctl
    progress
    protontricks
    python311Packages.i3ipc
    qrencode
    qutebrowser
    ranger
    ripgrep
    screen
    shellcheck
    shfmt
    sqlite
    sshfs
    stow
    tealdeer
    tigervnc
    tmux
    trash-cli
    udiskie
    unzip
    vim
    virt-manager
    vulkan-tools
    wget
    wine-staging
    winetricks
    wireguard-tools
    wl-clipboard
    wtype
    xml2
    yad
    yamllint
    ydotool
    yt-dlp
    zathura
    zip
    zoxide
    inputs.self.outputs.packages.x86_64-linux.host-lookup
  ];

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
