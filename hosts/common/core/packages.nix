{ pkgs, outputs, ... }: {
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
    prusa-slicer
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
    outputs.packages.x86_64-linux.host-lookup
  ];
}
