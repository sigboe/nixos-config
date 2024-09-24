{
  services.dunst = {
    enable = true;
    settings = {
      "global" = {
        "format" = "%a = %s %b";
        "sort" = "yes";
        "indicate_hidden" = "yes";
        "alignment" = "left";
        "bounce_freq" = 0;
        "show_age_threshold" = 60;
        "word_wrap" = "yes";
        "geometry" = "0x0+0+0";
        "transparency" = 0;
        "idle_threshold" = 20;
        "monitor" = 0;
        "follow" = "none";
        "sticky_history" = "yes";
        "line_height" = 0;
        "separator_height" = 2;
        "padding" = 2;
        "horizontal_padding" = 9;
        "browser" = "/usr/bin/firefox -new-tab";
        "mouse_left_click" = "do_action";
        "mouse_right_click" = "close_current";
        "mouse_middle_click" = "close_all";
      };
      "shortcuts" = {
        "close" = "mod4+x";
        "close_all" = "mod4+ctrl+x";
        "history" = "mod4+backslash";
      };
      "urgency_low" = {
        #"background" = "#859900";
        #        "foreground" = "#002b36";
        "timeout" = 10;
      };
      "urgency_normal" = {
        #        "background" = "#268bd2";
        #        "foreground" = "#eee8d5";
        "timeout" = 10;
      };
      "urgency_critical" = {
        #        "background" = "#dc322f";
        #        "foreground" = "#eee8d5";
        "timeout" = 0;
      };
      "ignore" = {
        "appname" = "Spotify";
        "summary" = "*";
        "format" = "";
      };
    };
  };
}
