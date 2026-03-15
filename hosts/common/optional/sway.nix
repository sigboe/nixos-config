{ pkgs, ... }: {
  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        autotiling
        bemenu
        bemoji
        bitwarden-rofi
        overskride # bluetooth
        bose-connect-app-linux
        brightnessctl
        dmenu
        foot
        grim
        imv
        j4-dmenu-desktop
        kitty
        libnotify
        maim
        networkmanagerapplet
        pinentry-bemenu
        python313Packages.i3ipc
        slurp
        sway-audio-idle-inhibit
        swayidle
        swaylock
        wl-clipboard
        wtype
        xdg-desktop-portal-wlr
      ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };
}
