{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    opencode
    claude-code
    inputs.caveman-ai.packages.x86_64-linux.caveman-cli
    nodejs_26
  ];
}
