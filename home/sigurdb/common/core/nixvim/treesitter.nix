{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
      enable = true;

        settings = {
          indent = {
            enable = true;
          };
          highlight = {
            enable = true;
          };
        };

        folding = true;
        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
      treesitter-context = {
        #enable = false;
      };
      treesitter-textobjects.settings = {
        #enable = true;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ii" = "@conditional.inner";
            "ai" = "@conditional.outer";
            "il" = "@loop.inner";
            "al" = "@loop.outer";
            "at" = "@comment.outer";
          };
        };
        move = {
          enable = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swapNext = {
            "<leader>a" = "@parameters.inner";
          };
          swapPrevious = {
            "<leader>A" = "@parameter.outer";
          };
        };
      };
    };
  };
}
