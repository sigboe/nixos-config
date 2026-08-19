{ pkgs, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.diffRenderers = [
        {
          colorArg = "always";
          command = "${pkgs.delta}/bin/delta --dark --paging=never";
        }
      ];
    };
  };
}
