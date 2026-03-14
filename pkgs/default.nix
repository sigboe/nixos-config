# You can build these directly using 'nix build .#example'
pkgs:
rec {
  bitwarden-rofi = pkgs.callPackage ./bitwarden-rofi { };
  bose-connect-app-linux = pkgs.callPackage ./bose-connect-app-linux { };
  host-lookup = pkgs.callPackage ./host-lookup { };
  TwilightBoxart = pkgs.callPackage ./TwilightBoxart { };
  powerbar = pkgs.callPackage ./powerbar { };
  tidal-dl-ng = pkgs.callPackage ./tidal-dl-ng { };
  tidal-dl-ng-gui = pkgs.writeShellScriptBin "tidal-dl-ng-gui" ''exec ${tidal-dl-ng}/bin/tidal-dl-ng-gui "$@"'';
  reolink-cli = pkgs.callPackage ./reolink-cli {};
}
