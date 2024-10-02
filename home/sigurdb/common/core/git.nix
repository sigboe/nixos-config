{
  programs = {
    git = {
      enable = true;
      userName = "sigboe";
      userEmail = "sigboe@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
      lfs.enable = true;
      delta.enable = true;
    };
    gh = {
      enable = true;
    };
    gh-dash.enable = true;
  };
}
