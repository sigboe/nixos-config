{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    opencode
    claude-code
  ];
}
