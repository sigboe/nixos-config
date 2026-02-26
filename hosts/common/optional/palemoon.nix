{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    palemoon-bin
  ];
}
