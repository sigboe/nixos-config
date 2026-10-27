{ pkgs, inputs, ... }: {
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
}
