{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    historyLimit = 100000;
    terminal = "tmux-256color";

    extraConfig = ''
      # Extended keyboard support
      set -s extended-keys on
      set -s extended-keys-format csi-u

      # Features supported by modern terminals
      set -as terminal-features ',xterm-kitty:extkeys:RGB:clipboard:focus'
      set -as terminal-features ',xterm-ghostty:extkeys:RGB:clipboard:focus'
      set -as terminal-features ',xterm*:extkeys:RGB'

      set -g allow-passthrough on
      set -g focus-events on
      set -sg escape-time 10

      # Toggle synchronized panes
      bind C-s set-window-option synchronize-panes

      # Switch panes with Ctrl+arrow
      bind -n C-Left select-pane -L
      bind -n C-Right select-pane -R
      bind -n C-Up select-pane -U
      bind -n C-Down select-pane -D
    '';
  };
}
