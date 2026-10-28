{ lib, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    opencode
    claude-code
    opencode-claude-auth
    inputs.caveman-ai.packages.x86_64-linux.caveman-cli
    rtk
    nodejs_26
    t3code
  ];
  networking.firewall = {
    allowedTCPPorts = [
      49374 # opencode2 remote
      4096 # opencode serve
      3773 # t3code
    ];
    allowedUDPPorts = [ ];
  };

  systemd.user.services.t3code = {
    description = "T3 Code server";
    # Off by default, hosts opt in with systemd.user.services.t3code.enable = true
    enable = lib.mkDefault false;
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    # Providers (claude, opencode, ...) are spawned from PATH
    path = with pkgs; [ claude-code opencode git openssh nodejs_26 ];
    serviceConfig = {
      ExecStart = "${pkgs.t3code}/bin/t3 serve --host 0.0.0.0 --port 3773 %h";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
