{ lib, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ControlMaster = "auto";
        ControlPath = "~/.ssh/controlmasters/%r@%h:%p";
        ControlPersist = "10m";
        AddKeysToAgent = "yes";
      };
      "mister" = {
        HostName = "10.10.1.21";
        User = "root";
      };
      "ziggurat" = {
        HostName = "ziggurat.tv";
        User = "sigurdb";
        ForwardAgent = true;
        LocalForward = [
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
        HostName = "10.10.1.54";
        User = "root";
      };
      "login i.bitbit.net" = {
        Host = "*login-*.i.bitbit.net";
        Port = 39029;
        ForwardAgent = true;
      };
      "import-osl2.api.c.bitbit.net" = {
        ForwardAgent = true;
      };
    };
  };
  home.activation.ensureControlmasterDir = lib.hm.dag.entryAfter [ "writeBoundry" ] ''
    run mkdir -p $HOME/.ssh/controlmasters
  '';
}
