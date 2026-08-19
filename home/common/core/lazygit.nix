{ pkgs, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.diffRenderers = [
        {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        }
      ];
    };
  };
}
