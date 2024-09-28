{ outputs
, pkgs
, ...
}: {
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        autotiling
        bemenu
        bemoji
        outputs.packages.x86_64-linux.bitwarden-rofi
        outputs.packages.x86_64-linux.bose-connect-app-linux
        blueberry
        brightnessctl
        dmenu
        dunst
        foot
        grim
        j4-dmenu-desktop
        kitty
        libnotify
        maim
        pinentry-bemenu
        slurp
        sway-audio-idle-inhibit
        swayidle
        swaylock
        wl-clipboard
        wtype
        xdg-desktop-portal-wlr
        xwaylandvideobridge
      ];
    };
    light.enable = true;
    waybar.enable = true;
  };

  systemd.user.services.waybar = {
    path = [ "/run/current-system/sw" ]; # /bin is added to this path automatically
    serviceConfig = {
      Restart = "on-failure";
      #RestartSec = 5; #seconds
      StartLimitIntervalSec = 0; #disable rate limiting
      StartLimitBurst = 9;
    };
  };
}