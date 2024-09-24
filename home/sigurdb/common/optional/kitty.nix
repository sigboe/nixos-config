{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      #      foreground = "#839496";
      #      background = "#002b36";
      #      selection_foreground = "#93a1a1";
      #      selection_background = "#073642";
      cursor_opacity = "0.7";
      # Colors:
      #      cursor = "#fdf6e3";
      #      active_border_color = "#859900";
      #      inactive_border_color = "#073642";
      #      active_tab_foreground = "#839496";
      #      active_tab_background = "#002b36";
      #      inactive_tab_foreground = "#93a1a1";
      #      inactive_tab_background = "#fdf6e3";
      #      color0 = "#073642";
      #      color8 = "#002b36";
      #      color1 = "#dc322f";
      #      color9 = "#cb4b16";
      #      color2 = "#859900";
      #      color10 = "#586e75";
      #      color3 = "#b58900";
      #      color11 = "#657b83";
      #      color4 = "#268bd2";
      #      color12 = "#839496";
      #      color5 = "#d33682";
      #      color13 = "#6c71c4";
      #      color6 = "#2aa198";
      #      color14 = "#93a1a1";
      #      color7 = "#eee8d5";
      #      color15 = "#fdf6e3";
    };
    keybindings = {
      "ctrl+0x2b" = "change_font_size all +2.0";
      "ctrl+0x2d" = "change_font_size all -2.0";
      "kitty_mod+minus" = "no_op";
      "kitty_mod+backspace" = "change_font_size all 0";
    };
  };
}
