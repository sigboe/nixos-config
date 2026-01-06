{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    forge-mtg
  ];
}
