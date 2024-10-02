{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    historyLimit = 100000;
    extraConfig = ''
      # enable disable pane syncronize
      bind C-s set-window-option synchronize-panes
      # switch panes using Ctrl-arrow without prefix
      bind -n C-Left select-pane -L
      bind -n C-Right select-pane -R
      bind -n C-Up select-pane -U
      bind -n C-Down select-pane -D
    '';
  };
}
