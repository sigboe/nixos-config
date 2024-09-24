{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    grml-zsh-config
  ];
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
            source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      # Add nix-shell indicator that makes clear when we're in nix-shell.
      # Set the prompt items to include it in addition to the defaults:
      # Described in: http://bewatermyfriend.org/p/2013/003/
            function nix_shell_prompt () {
              REPLY=''${IN_NIX_SHELL+"(nix-shell) "}
            }
          grml_theme_add_token nix-shell-indicator -f nix_shell_prompt '%F{magenta}' '%f'
            zstyle ':prompt:grml:left:setup' items rc nix-shell-indicator change-root user at host path vcs percent
      #plugins
            source ${pkgs.google-cloud-sdk}/google-cloud-sdk/path.zsh.inc
            source ${pkgs.fzf}/share/fzf/key-bindings.zsh
            source ${pkgs.fzf}/share/fzf/completion.zsh
            source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
    promptInit = ""; # otherwise it'll override the grml prompt
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  environment.shellAliases = {
    # disable distro default aliases, because we set them our self
    # at least for the time being
    ls = null;
    ll = null;
    l = null;
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;
}
