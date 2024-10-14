{ pkgs, ... }:
let
  boseBattery = pkgs.writers.writeDash "bose-battery.sh" (builtins.readFile ./bose-battery.sh);
  volumePipewire = pkgs.writers.writeBash "volume-pipewire.sh" (builtins.readFile ./volume-pipewire.sh);
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "custom/audio_idle_inhibitor"
          "idle_inhibitor"
          "custom/bose"
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "bluetooth"
          "battery"
          "clock"
          "tray"
        ];

        "sway/workspaces" = {
          window-rewrite = { };
          warp-on-scroll = false;
          enable-bar-scroll = true;
          disable-scroll-wraparound = true;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };
        "custom/bose" = {
          exec = "${boseBattery}";
          interval = 5;
          format = "{}";
        };
        "custom/audio_idle_inhibitor" = {
          format = "{icon}";
          exec = "${pkgs.sway-audio-idle-inhibit} --dry-print-both-waybar";
          exec-if = "which sway-audio-idle-inhibit";
          return-type = "json";
          format-icons = {
            output = "";
            input = "";
            output-input = "  ";
            none = "";
          };
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        "sway/mode" = {
          format = "<span style='italic'> {} </span>";
        };
        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = { on = " "; };
          random-icons = {
            off = "<span color='#f53c3c'></span> ";
            on = " ";
          };
          repeat-icons = { on = " "; };
          single-icons = { on = "1 "; };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = { spacing = 10; };
        clock = {
          tooltip-format = "<tt>{calendar}</tt>";
          format = "{:%a %d %b %H:%M}";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "left";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<big><span color='#eee8d5' text_transform='capitalize' allow_breaks='false'><b>{}</b></span></big>";
              days = "<span color='#fdf6e3' allow_breaks='false'><b>{}</b></span>";
              weeks = "<span color='#859900' allow_breaks='false'><b>{}</b></span>";
              weekdays = "<span color='#b58900' allow_breaks='false'><b>{}</b></span>";
              today = "<span color='#d33682'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = { format = "{}% "; };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        "battery#bat2" = { bat = "BAT2"; };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        "custom/pipewire" = {
          format = "{}";
          interval = 1;
          exec = "${volumePipewire}|head -n1";
          on-click = "BLOCK_BUTTON=1 $HOME/.local/bin/i3blocks.d/volume-pipewire";
          on-middle-click = "BLOCK_BUTTON=2 $HOME/.local/bin/i3blocks.d/volume-pipewire";
          on-right-click = "BLOCK_BUTTON=3 $HOME/.local/bin/i3blocks.d/volume-pipewire";
          signal = "1";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        bluetooth = {
          format = " {status}";
          format-disabled = " ";
          format-connected = " {num_connections} connected";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = ''
            {controller_alias}	{controller_address}

            {device_enumerate}'';
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        };
      };
    };
    style = ''
      #mode {
        background-color: @base08;
        color: @base00;
        border-radius: 3px;
      }
      #battery.critical:not(.charging) {
          background-color: @base08;
          color: @base00;
          animation-name: blink;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      #battery.charging, #battery.plugged {
        color: @base00;
        background-color: @base0C;
      }
    '';
  };
}
