{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    historyLimit = 100000;
    terminal = "tmux-256color";

    extraConfig = ''
      # Extended keys (Ctrl, Alt, Shift combinations)
      set -s extended-keys on

      # Use xterm-compatible encoding for broad application compatibility.
      set -s extended-keys-format xterm

      # Advertise only capabilities supported by these terminals.
      set -as terminal-features ',xterm-kitty:RGB:extkeys:clipboard:focus'
      set -as terminal-features ',xterm-ghostty:RGB:extkeys:clipboard:focus'

      # Focus reporting
      set -g focus-events on

      # Output passthrough, useful for applications using terminal graphics.
      # Not required for keyboard handling.
      set -g allow-passthrough on

      set -sg escape-time 10

      # Synchronized panes
      bind C-s set-window-option synchronize-panes

      # Pane navigation using the prefix.
      bind -r Left select-pane -L
      bind -r Right select-pane -R
      bind -r Up select-pane -U
      bind -r Down select-pane -D

      # Status bar
      set -g status-position bottom
      set -g status-interval 5
      set -g status-justify centre
      set -g status-left-length 32
      set -g status-right-length 100

      set -g status-style 'fg=colour245,bg=colour234'
      set -g status-left-style 'fg=colour231,bg=colour31,bold'
      set -g status-right-style 'fg=colour245,bg=colour234'

      set -g status-left ' #S '

      set -g status-right '#[fg=colour81,bold]#{pane_current_command}#[default]  #[fg=colour245]#{b:pane_current_path}#[default]  #[fg=colour39]#h#[default]  #[fg=colour244]%a %d %b %H:%M '

      setw -g window-status-style 'fg=colour245,bg=colour234'
      setw -g window-status-current-style 'fg=colour81,bg=colour234,bold'
      setw -g window-status-activity-style 'fg=colour220,bg=colour234,bold'
      setw -g window-status-bell-style 'fg=colour196,bg=colour234,bold'

      setw -g window-status-format ' #I:#W#F '
      setw -g window-status-current-format '#[fg=colour81,bold] #I:#W#F #[default]'

      setw -g monitor-activity on
      set -g renumber-windows on
    '';
  };
}
