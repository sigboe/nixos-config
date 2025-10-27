{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "sigboe";
          email = "sigboe@gmail.com";
        };
        init.defaultBranch = "main";
      };
      lfs.enable = true;
      #delta.enable = true;
    };
    gh = {
      enable = true;
    };
    gh-dash.enable = true;
  };
}
