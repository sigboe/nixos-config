{ lib
, config
, pkgs
, ...
}:
let
  swayPrintscreen = pkgs.writers.writeBash "sway-printscreen.sh" (builtins.readFile ./sway-printscreen.sh);
  dmenuworkpass = pkgs.writeScriptBin "dmenuworkpass.sh" (builtins.readFile ./dmenuworkpass.sh);
  yubikey-oath-dmenu = pkgs.writers.writePython3 "yubikey-oath-dmenu.py"
    {
      libraries = [ pkgs.python311Packages.click pkgs.yubikey-manager ];
      flakeIgnore = [ "E501" "E265" "E302" "E251" "W503" ];
    }
    (builtins.readFile ./yubikey-oath-dmenu.py);
  powerMenu = "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";
      terminal = "${pkgs.kitty}/bin/kitty -o allow_remote_control=yes -o enable_layouts=tall";
      menu = ''${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu='${pkgs.bemenu}/bin/bemenu ${config.home.sessionVariables.BEMENU_OPTS}' --term="kitty"'';
      defaultWorkspace = "workspace number 1";
      keybindings =
        let
          inherit (config.wayland.windowManager.sway.config) modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
          # switch workspaces
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 0";
          # Move focused container to workspace
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 0";
          # splits
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          # Switch the current container between different layout styles
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          # fullscreen
          "${modifier}+f" = "fullscreen";
          # floating
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          # focus
          "${modifier}+a" = "focus parent";
          # Scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";
          # restart sway in place
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+x" = "exec swaylock";
          # Printscreen
          "Print" = "exec ${swayPrintscreen} screen";
          "${modifier}+Shift+P" = "exec ${swayPrintscreen} selection";
          "${modifier}+Ctrl+P" = "exec ${swayPrintscreen} window";
          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          ## Brightness control
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

          # Password managers
          "${modifier}+Comma" = "exec ${dmenuworkpass}/bin/dmenuworkpass.sh --type";
          "${modifier}+Period" = "exec bwmenu --ask-password-command 'bemenu -password indicator --prompt BitWarden' --search-command 'bemenu ${config.home.sessionVariables.BEMENU_OPTS}'";

          # Emojis
          "${modifier}+Shift+s" = "exec ${pkgs.bemoji}/bin/bemoji";

          # yubikey
          "${modifier}+Shift+o" = ''exec ${yubikey-oath-dmenu} --menu-cmd '${pkgs.bemenu}/bin/bemenu ${config.home.sessionVariables.BEMENU_OPTS} -p "Credentials to copy:"' --notify --clipboard'';
          "${modifier}+o" = ''exec ${yubikey-oath-dmenu} --menu-cmd '${pkgs.bemenu}/bin/bemenu ${config.home.sessionVariables.BEMENU_OPTS} -p "Credentials to copy:"' --notify --type'';
          # modes
          "${modifier}+r" = "mode resize";
          "${modifier}+Delete" = "mode \"${powerMenu}\"";
        };
      keycodebindings."172" = "exec --no-startup-id playerctl play-pause";
      modes = {
        resize = {
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";
          "Left" = "resize shrink width 10 px";
          "Down" = "resize grow height 10 px";
          "Up" = "resize shrink height 10 px";
          "Right" = "resize grow width 10 px";
          # back to normal: Enter or Escape
          "Escape" = "mode default";
          "Return" = "mode default";
        };
        "${powerMenu}" = {
          "l" = "exec --no-startup-id swaylock ; mode default";
          "e" = "exec --no-startup-id swaymsg exit";
          "s" = "exec --no-startup-id swaylock ; mode default ; exec --no-startup-id systemctl suspend";
          "h" = "exec --no-startup-id swaylock ; mode default ; exec --no-startup-id systemctl hibernate";
          "r" = "exec --no-startup-id systemctl reboot";
          "Shift+s" = "exec --no-startup-id systemctl poweroff -i";

          # back to normal: Enter or Escape
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
      startup = [
        { command = "--no-startup-id systemctl --user start waybar"; }
        {
          #command = "--no-startup-id ${autotiling}";
          command = "--no-startup-id autotiling";
          always = true;
        }
        { command = "--no-startup-id nm-applet --indicator"; }
        { command = "--no-startup-id udiskie -ans &"; }
        { command = "--no-startup-id wl-paste -t text --watch clipman store --no-persist"; }
        { command = "--no-startup-id kanshi &"; }
        {
          command = "--no-startup-id kanshictl reload";
          always = true;
        }
        { command = "--no-startup-id sway-audio-idle-inhibit"; }
        # auto lockscreen
        {
          command = ''
            swayidle -w \
              timeout 300 'swaylock' \
              timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
              before-sleep 'swaylock'
          '';
        }
        { command = "swaymsg rename workspace 1 '1 '"; }
        { command = "swaymsg rename workspace 2 '2 '"; }
        # workspace names
      ];
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          click_method = "clickfinger";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "no";
          xkb_options = "ctrl:nocaps";
        };
      };
      focus = {
        followMouse = true;
        mouseWarping = true;
      };
      window = {
        border = 1;
        commands = [
          {
            criteria = { class = ".*"; };
            command = "border pixel 1";
          }
          {
            criteria = { app_id = "yad"; };
            command = "floating enable, border pixel 0";
          }
          {
            criteria = { app_id = "firefox"; };
            command = "border pixel 0";
          }
          {
            criteria = { title = "Firefox — Sharing Indicator"; };
            command = "floating enable, nofocus";
          }
          {
            criteria = { app_id = "chromium-browser"; };
            command = "border pixel 0";
          }
          {
            criteria = { window_role = "floating"; };
            command = "floating enable";
          }
          {
            criteria = { instance = "Navigator"; };
            command = "floating disable";
          }
          {
            criteria = { app_id = "gamescope"; };
            command = "floating enable";
          }
          {
            criteria = {
              app_id = "^firefox$";
              title = "^Extension: \(Bitwarden - Free Password Manager\) - Bitwarden — Mozilla Firefox$";
            };
            command = "floating enable";
          }
        ];
      };
      bars = [ ];
    };
    extraConfig = ''
      # laptop lid
      set $laptop_sceen eDP-1
      bindswitch --locked --reload lid:on output $laptop_sceen disable
      bindswitch --locked --reload lid:off output $laptop_sceen enable
    '';
  };
  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
    };
  };
  programs.bemenu.settings = {
    ignorecase = true;
    fb = config.lib.stylix.colors.withHashtag.base00;
    ff = config.lib.stylix.colors.withHashtag.base05;
    nb = config.lib.stylix.colors.withHashtag.base00;
    nf = config.lib.stylix.colors.withHashtag.base05;
    tb = config.lib.stylix.colors.withHashtag.base00;
    hb = config.lib.stylix.colors.withHashtag.base00;
    tf = config.lib.stylix.colors.withHashtag.base08;
    hf = config.lib.stylix.colors.withHashtag.base0A;
    af = config.lib.stylix.colors.withHashtag.base05;
    ab = config.lib.stylix.colors.withHashtag.base00;
  };
  # programs.bemenu.settings seams to not work so here is a workaround
  home.sessionVariables = {
    BEMENU_OPTS = ''--ignorecase --fb "${config.lib.stylix.colors.withHashtag.base00}" --ff "${config.lib.stylix.colors.withHashtag.base05}" --nb "${config.lib.stylix.colors.withHashtag.base00}" --nf "${config.lib.stylix.colors.withHashtag.base05}" --tb "${config.lib.stylix.colors.withHashtag.base00}" --hb "${config.lib.stylix.colors.withHashtag.base00}" --tf "${config.lib.stylix.colors.withHashtag.base08}" --hf "${config.lib.stylix.colors.withHashtag.base0A}" --af "${config.lib.stylix.colors.withHashtag.base05}" --ab "${config.lib.stylix.colors.withHashtag.base00}"'';
  };
}
