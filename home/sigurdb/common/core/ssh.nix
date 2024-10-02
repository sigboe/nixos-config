{ lib, ... }: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/controlmasters/%r@%h:%p";
    controlPersist = "yes";
    addKeysToAgent = "yes";
    matchBlocks = {
      "mister" = {
        hostname = "10.10.1.21";
        user = "root";
      };
      "ziggurat" = {
        hostname = "ziggurat.tv";
        user = "sigurdb";
        forwardAgent = true;
        localForwards = [
          {
            bind.port = 8080;
            host.address = "zig-ut-01.local";
            host.port = 80;
          }
          {
            bind.port = 8081;
            host.address = "10.10.1.1";
            host.port = 81;
          }
        ];
      };
      "zig-ut-01" = {
        hostname = "10.10.1.54";
        user = "root";
      };
      "login i.bitbit.net" = {
        host = "*login-*.i.bitbit.net";
        port = 39029;
        forwardAgent = true;
      };
      "import-osl2.api.c.bitbit.net" = {
        forwardAgent = true;
      };
    };
  };
  home.activation.ensureControlmasterDir = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    run mkdir -p $HOME/.ssh/controlmasters
  '';
}
