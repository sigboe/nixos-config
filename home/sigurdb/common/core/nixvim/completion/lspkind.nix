{
  programs.nixvim = {
    plugins.lspkind = {
      enable = true;
      settings = {
        maxwidth = 50;
        ellipsis_char = "...";
        symbol_map = {
          Copilot = "";
        };
      };
    };
  };
}
