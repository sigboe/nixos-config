{ inputs
, pkgs
, ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./completion/cmp.nix
    ./completion/lspkind.nix
    ./completion/schemastore.nix

    ./lsp/conform.nix
    ./lsp/fidget.nix
    ./lsp/lsp.nix
    ./lsp/trouble.nix

    ./luasnip.nix
    ./treesitter.nix

  ];

  programs.nixvim = {
    enable = true;
    nixpkgs.config.allowUnfree = true;
    defaultEditor = true;
    enableMan = true; # install man pages for nixvim options

    clipboard = {
      register = "unnamedplus"; # use system clipboard instead of internal registers
      providers.wl-copy.enable = true;
    };

    opts = {
      # # Lua reference:
      # vim.o behaves like :set
      # vim.go behaves like :setglobal
      # vim.bo for buffer-scoped options
      # vim.wo for window-scoped options (can be double indexed)

      #
      # ========= General Appearance =========
      #
      hidden = true; # Makes vim act like all other editors, buffers can exist in the background without being in a window. http://items.sjbach.com/319/configuring-vim-right
      number = true; # show line numbers
      relativenumber = true; # show relative linenumbers
      laststatus = 0; # Display status line always
      history = 1000; # Store lots of :cmdline history
      showcmd = true; # Show incomplete cmds down the bottom
      showmode = true; # Show current mode down the bottom
      autoread = true; # Reload files changed outside vim
      lazyredraw = true; # Redraw only when needed
      showmatch = true; # highlight matching braces
      ruler = true; # show current line and column
      visualbell = true; # No sounds
      mouse = "a";
      virtualedit = "block";
      breakindent = true;
      signcolumn = "yes";

      list = true;
      listchars = "trail:·,nbsp:◦"; # Display tabs and trailing spaces visually

      wrap = false; # Don't wrap lines
      linebreak = true; # Wrap lines at convenient points

      # ========= Cursor =========
      guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n-v-i:blinkon0";

      # ========= Redirect Temp Files =========
      # backup
      backupdir = "$HOME/.vim/backup//,/tmp//,.";
      writebackup = false;
      # swap
      directory = "$HOME/.vim/swap//,/tmp//,.";

      # ================ Indentation ======================
      autoindent = true;
      cindent = true; # automatically indent braces
      smartindent = true;
      smarttab = true;
      shiftwidth = 4;
      softtabstop = 4;
      tabstop = 4;
      expandtab = true;

      # ================ Folds ============================
      foldmethod = "indent"; # fold based on indent
      foldnestmax = 3; # deepest fold is 3 levels
      foldenable = false; # don't fold by default

      # ================ Completion =======================
      wildmode = "list:longest,full";
      wildmenu = true; # enable ctrl-n and ctrl-p to scroll thru matches
      wildignorecase = true;
      wildoptions = "pum";

      # stuff to ignore when tab completing
      wildignore = "*.o,*.obj,*~,vim/backups,sass-cache,DS_Store,vendor/rails/**,vendor/cache/**,*.gem,log/**,tmp/**,*.png,*.jpg,*.gif";

      # ================ Scrolling ========================
      scrolloff = 4; # Start scrolling when we're 4 lines away from margins
      sidescrolloff = 15;
      sidescroll = 1;

      # ================ Searching ========================
      incsearch = true;
      hlsearch = true;
      ignorecase = true;
      smartcase = true;

      # ================ Movement ========================
      backspace = "indent,eol,start"; # allow backspace in insert mode
    };

    #
    # ========= UI Plugins =========
    #

    plugins = {
      # Display colors for when # FFFFFF codes are detected in buffer text.
      colorizer = {
        enable = true;
      };

      lualine.enable = true;


      # ========= Undo history ========
      # TODO: nixvim: set up    alos, map to <leader>u
      # undotree = {};

      #
      # ========= File Search =========
      #
      telescope = {
        # https://github.com/nvim-telescope/telescope.nvim
        enable = true;
        extensions.fzy-native.enable = true;
      };

      # ========= File Nav ===========
      # TODO: nixvim set this one up
      # harpoon = {};

      #
      # ========== Dev Tools =========
      #
      lazygit.enable = true;
      fugitive.enable = true;
      gitgutter.enable = true;
      vim-surround.enable = true;
      sleuth.enable = true; # autodetect tabstop and shiftwidth
      nvim-autopairs.enable = true;
      which-key.enable = true;
      comment.enable = true;
      nix.enable = true;
      #indent-blankline.enable = true;
      mini = {
        enable = true;
        modules = {
          indentscope.symbol = "│";
        };
      };
      web-devicons.enable = false;
      claude-code.enable = true;
      #lint = {
      #  enable = true;
      #  lintersByFt = {
      #    nix = ["alejandra"];
      #  };
      #};
    };

    # Load Plugins that aren't provided as modules by nixvim
    extraPlugins = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        vim-illuminate# Highlight similar words as are under the cursor
        vim-numbertoggle# Use relative number on focused buffer only
        range-highlight-nvim# Highlight range as specified in commandline e.g. :10,15
        vimade# Dim unfocused buffers
        vim-rhubarb
        vim-twiggy# Fugitive plugin to add branch control
        vimwiki# Vim Wiki
        #YouCompleteMe        # Code completion engine
        quick-scope

        supertab# Use <tab> for insert completion needs - https://github.com/ervandew/supertab/

        # Keep vim-devicons as last entry
        vim-devicons
        ;
    };

    # ========= Mapleader =========
    globals = {
      mapleader = " ";
    };

    #
    # ========= Key binds =========
    #
    # MODES Key:
    #    "n" Normal mode
    #    "i" Insert mode
    #    "v" Visual and Select mode
    #    "s" Select mode
    #    "t" Terminal mode
    #    ""  Normal, visual, select and operator-pending mode
    #    "x" Visual mode only, without select
    #    "o" Operator-pending mode
    #    "!" Insert and command-line mode
    #    "l" Insert, command-line and lang-arg mode
    #    "c" Command-line mode
    keymaps = [
      {
        # reload vimrc
        mode = [ "n" ];
        key = "<Leader>vr";
        action = "<cmd>so $MYVIMRC<CR>";
        options = {
          noremap = true;
        };
      }
      {
        # clear search highlighting
        mode = [ "n" ];
        key = "<space><space>";
        action = "<cmd>nohlsearch<CR>";
        options = {
          noremap = true;
        };
      }

      # ======== Movement ========
      {
        # move down through wrapped lines
        mode = [ "n" ];
        key = "j";
        action = "gj";
        options = {
          noremap = true;
        };
      }
      {
        # move up through wrapped lines
        mode = [ "n" ];
        key = "k";
        action = "gk";
        options = {
          noremap = true;
        };
      }
      {
        # rebind 1/2 page down
        mode = [ "n" ];
        key = "<C-j>";
        action = "<C-d>";
        options = {
          noremap = true;
        };
      }
      {
        # rebind 1/2 page up
        mode = [ "n" ];
        key = "<C-k>";
        action = "<C-u>";
        options = {
          noremap = true;
        };
      }
      {
        # move to beginning/end of line
        mode = [ "n" ];
        key = "E";
        action = "$";
        options = {
          noremap = true;
        };
      }
      # {
      #   # disable default move to beginning/end of line
      #   mode = ["n"];
      #   key = "$";
      #   action = "<nop>";
      # }

      # =========== Fugitive Plugin =========
      {
        # quick git status
        mode = [ "n" ];
        key = "<Leader>gs";
        action = "<cmd>G<CR>";
        options = {
          noremap = true;
        };
      }
      {
        # quick merge command: take from right page (tab 3) upstream
        mode = [ "n" ];
        key = "<Leader>gj";
        action = "<cmd>diffget //3<CR>";
        options = {
          noremap = true;
        };
      }
      {
        # quick merge command: take from left page (tab 2) head
        mode = [ "n" ];
        key = "<Leader>gf";
        action = "<cmd>diffget //2<CR>";
        options = {
          noremap = true;
        };
      }

      # ========== Telescope Plugin =========
      {
        # find files
        mode = [ "n" ];
        key = "<Leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options = {
          noremap = true;
        };
      }
      {
        # live grep
        mode = [ "n" ];
        key = "<Leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options = {
          noremap = true;
        };
      }
      {
        # buffers
        mode = [ "n" ];
        key = "<Leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options = {
          noremap = true;
        };
      }
      {
        # help tags
        mode = [ "n" ];
        key = "<Leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options = {
          noremap = true;
        };
      }

      # ========= Twiggy =============
      {
        # toggle display twiggy
        mode = [ "n" ];
        key = "<Leader>tw";
        action = ":Twiggy<CR>";
        options = {
          noremap = true;
        };
      }
      # ========= GitGutter =============
      {
        mode = [ "n" ];
        key = "<Leader>gn";
        action = "<Plug>(GitGutterNextHunk)";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = [ "n" ];
        key = "<Leader>gp";
        action = "<Plug>(GitGutterPrevHunk)";
        options = {
          noremap = true;
          silent = true;
        };
      }
      # ========= claude-code =========
      { key = "<leader>ac"; action = "<cmd>ClaudeCode<cr>"; }
      { key = "<leader>af"; action = "<cmd>ClaudeCodeFocus<cr>"; }
      { key = "<leader>ar"; action = "<cmd>ClaudeCode --resume<cr>"; }
      { key = "<leader>aC"; action = "<cmd>ClaudeCode --continue<cr>"; }
      { key = "<leader>ab"; action = "<cmd>ClaudeCodeAdd %<cr>"; }
      { key = "<leader>as"; action = "<cmd>ClaudeCodeSend<cr>"; mode = [ "v" ]; }
      { key = "<leader>aa"; action = "<cmd>ClaudeCodeDiffAccept<cr>"; }
      { key = "<leader>ad"; action = "<cmd>ClaudeCodeDiffDeny<cr>"; }
      # ========= Move in Insert Mode =============
      {
        mode = [ "i" ];
        key = "<C-h>";
        action = "<Left>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = [ "i" ];
        key = "<C-j>";
        action = "<Down>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = [ "i" ];
        key = "<C-k>";
        action = "<Up>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = [ "i" ];
        key = "<C-l>";
        action = "<Right>";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];
    extraConfigVim = ''
      " ================ Persistent Undo ==================
      " Keep undo history across sessions, by storing in file.
      " Only works all the time.
      if has('persistent_undo')
          silent !mkdir ~/.vim/backups > /dev/null 2>&1
          set undodir=~/.vim/backups
          set undofile
      endif
    '';

    extraConfigLua = ''
      vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

      -- [[ Highlight on yank ]]
      -- See `:help vim.highlight.on_yank()`
      local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
      vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
          vim.highlight.on_yank({timeout=1000})
        end,
        group = highlight_group,
        pattern = '*',
      })

    '';
  };
}
# # Syntax support
# vim-polyglot # a collection of language packs for vim
#
# # The following are commented out because they are already included in vim-polyglot
# # but in case poly-glot fails I want to be able to quickly enable what I need.
# haskell-vim
# plantuml-syntax
# pgsql-vim
# python-syntax
# rust-vim
# vim-markdown
# vim-nix
# vim-terraform
# vim-toml
