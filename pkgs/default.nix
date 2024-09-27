# You can build these directly using 'nix build .#example'
pkgs: {
  #################### Packages with external source ####################

  bitwarden-rofi = pkgs.callPackage ./bitwarden-rofi {};
  bose-connect-app-linux = pkgs.callPackage ./bose-connect-app-linux {};
  host-lookup = pkgs.callPackage ./host-lookup {};
}
