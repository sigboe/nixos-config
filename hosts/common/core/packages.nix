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
    exiftool
    eza
    fd
    ffmpeg
    firefox
    freetype
    furmark
    fzf
    gamescope
    gcc
    gdu
    git
    github-cli
    gnutls
    go
    handbrake
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
    mediainfo
    mpd
    mpv
    ncdu
    networkmanagerapplet
    nixd
    nodejs_22
    openldap
    p7zip
    pass
    pavucontrol
    pciutils
    playerctl
    progress
    protontricks
    prusa-slicer
    psmisc
    python311Packages.i3ipc
    qrencode
    qutebrowser
    ranger
    ripgrep
    screen
    shellcheck
    shfmt
    signal-desktop
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
    wdisplays
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
