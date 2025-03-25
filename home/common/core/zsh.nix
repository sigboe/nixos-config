{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    shellGlobalAliases = {
      "..." = "../..";
      "..4" = "../../..";
      "..5" = "../../../..";
      "..6" = "../../../../..";
      "..7" = "../../../../../..";
      L = "| less";
      LL = "| less -R -X -F";
      G = "|rg";
    };
    shellAliases = {
      tb = "${pkgs.netcat}/bin/nc termbin.com 9999";
      whois = "ssh login-osl1.i.bitbit.net whois -h registrarwhois.norid.no";
      icat = "kitty +kitten icat";
      kssh = "kitty +kitten kssh";
      vimdiff = "nvim";
      vim = "nvim";
      rm = "trash-put";
      ls = "eza --icons=always --color=always";
      dir = "eza -lSrah --icons=always --color=always";
      l = "eza -l --icons=always --color=always";
      la = "eza -la --icons=always --color=always";
      lh = "eza -hAl --icons=always --color=always";
      ll = "eza -l --icons=always --color=always";
      lt = "eza --tree --icons=always --color=always";
      lsbig = "eza -flh --icons=always --color=always *(.OL[1,10])";
      lsd = "eza -d --icons=always --color=always *(/)";
      lse = "eza -d --icons=always --color=always *(/^F)";
      lsl = "eza -lFX --icons=always --color=always | rg -- '->'";
      egrep = "rg --color=auto";
      grep = "rg --color=auto";
      cat = "bat";
    };
    dotDir = ".config/zsh/zshrc";
    initExtraBeforeCompInit = ''
    '';
    initExtra = ''
      setopt complete_aliases

      if [[ -d "''${HOME}/.local/share/work-password-store" ]]; then
        compdef _pass workpass
        zstyle ':completion::complete:workpass::' prefix "''${HOME}/.local/share/work-password-store"
        function workpass() {
          PASSWORD_STORE_DIR=~/.local/share/work-password-store  "''${HOME}/.local/share/work-password-store/bin/pass" git pull --rebase > /dev/null;
          PASSWORD_STORE_DIR=~/.local/share/work-password-store "''${HOME}/.local/share/work-password-store/bin/pass" "$@"
       }
      fi

      function s, {
        export NIX_INDEX_DATABASE="''${HOME}/.cache/nix-index/"
        sudo env NIX_INDEX_DATABASE="''${NIX_INDEX_DATABASE}" sh -c "${pkgs.comma}/bin/comma $(printf '%q ' "''${@}")"
      }

      function vimscp {
        # put all arguments in array
        args=( "''${@}" )

        # convert arguments to vim url
        for ((i = 1; i <= $#args; i++)); do
          # only if they contain :
          if [[ "''${args[i]}" == *":"* ]]; then
            address="''${args[i]%:*}"
            file="''${args[i]##*:}"
            args[i]="scp://''${address}/''${file}"
        fi
        done
        ${pkgs.neovim}/bin/nvim - o ''${args}
      }

      ranger() {
        temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
        ${pkgs.ranger}/bin/ranger --choosedir="$temp_file" -- "''${@:-$PWD}"
        if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
          builtin cd -- "$chosen_dir"
        fi
        command rm -f -- "$temp_file"
      }
      function ya() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
 
      _tldr_complete() {
        local word="$1"
        local cmpl=""
        if [ "$word" = "-" ]; then
          cmpl=$(echo $'\n-v\n-h\n-u\n-c\n-p\n-r' | sort)
        elif [ "$word" = "--" ]; then
          cmpl=$(echo $'--version\n--help\n--update\n--clear-cache\n--platform\n--render' | sort)
        else
          if [ -d "$HOME/.tldrc/tldr/pages" ]; then
            local platform="$(uname)"
            cmpl="$(_tldr_get_files common | sort | uniq)"
            if [ "$platform" = "Darwin" ]; then
              cmpl="''${cmpl}$(_tldr_get_files osx | sort | uniq)"
            elif [ "''$platform" = "Linux" ]; then
              cmpl="''${cmpl}$(_tldr_get_files linux | sort | uniq)"
            elif [ "''$platform" = "SunOS" ]; then
              cmpl="''${cmpl}$(_tldr_get_files sunos | sort | uniq)"
            fi
          fi
        fi
        reply=( "''${(ps:\n:)cmpl}" )
      }

      compctl -K _tldr_complete tldr

      nsupd() { ${pkgs.dnsutils}/bin/nsupdate -k$HOME/.config/dns/$USER.user.private "$@"; }

      if [[ -e ~/git/gh/amedia/k8s-objects/tools/run.sh ]]; then
        source ~/git/gh/amedia/k8s-objects/tools/run.sh alias > /dev/null
      fi

      # Enable Ctrl-U to cut backwards
      bindkey \^U backward-kill-line

      # Enable Ctrl-x-e to edit command line
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^xe' edit-command-line
      bindkey '^x^e' edit-command-line

      compdef kssh=ssh
      compdef vimscp=scp
      compdef _eza ls
    '';
  };
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
    };
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    tealdeer = {
      enable = true;
      settings = {
        auto_update = true;
      };
    };
    # Yazi Zsh integration conflicts with zoxide. We just do it our self above.
    yazi = {
      enable = true;
      #  enableZshIntegration = true;
    };
  };
  services.gpg-agent.enableZshIntegration = true;
}
