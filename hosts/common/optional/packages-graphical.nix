{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    SDL2
    chromium
    freetype
    handbrake
    imagemagick
    libreoffice
    mangohud
    mpv
    pavucontrol
    playerctl
    qutebrowser
    signal-desktop
    tigervnc
    udiskie
    wdisplays
    yad
    ydotool
    zathura
    zenity
  ] ++
  (if pkgs.hostPlatform.isx86 then [
    TwilightBoxart
    lutris
    protontricks
    wine-staging
    winetricks
    grayjay
  ] else [ ]);

}
