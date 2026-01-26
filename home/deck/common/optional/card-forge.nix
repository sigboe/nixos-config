{ pkgs, ... }: {
  home.packages = with pkgs; [
    forge-mtg
  ];
}
