{ pkgs, outputs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    SDL2
    TwilightBoxart
    acpi
    alejandra
    ansible-language-server
    ansible-lint
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
    host-lookup
    htop
    imagemagick
    jq
    kanshi
    lazygit
    libgpg-error
    libreoffice
    libxml2
    lutris
    mangohud
    mediainfo
    mpd
    mpv
    ncdu
    networkmanagerapplet
    openldap
    p7zip
    pass
    pavucontrol
    pciutils
    playerctl
    progress
    protontricks
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
    tealdeer
    tigervnc
    tmux
    trash-cli
    udiskie
    unzip
    vim
    vulkan-tools
    wdisplays
    wget
    wine-staging
    winetricks
    wireguard-tools
    xml2
    yad
    yamllint
    ydotool
    yt-dlp
    zathura
    zip
    zoxide
    unstable.nixd
    inputs.zen-browser.packages."${system}".twilight
  ];

}
