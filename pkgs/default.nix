# You can build these directly using 'nix build .#example'
pkgs:
rec {
  dr_libs = pkgs.callPackage ./dr_libs { };
  bgfx = pkgs.callPackage ./bgfx { };
  bgfx_cmake = pkgs.callPackage ./bgfx_cmake { };
  imgui_cmake = pkgs.callPackage ./imgui_cmake { };
  bitwarden-rofi = pkgs.callPackage ./bitwarden-rofi { };
  bose-connect-app-linux = pkgs.callPackage ./bose-connect-app-linux { };
  host-lookup = pkgs.callPackage ./host-lookup { };
  openblack = pkgs.callPackage ./openblack {
    inherit dr_libs bgfx bgfx_cmake imgui_cmake;
  };
  TwilightBoxart = pkgs.callPackage ./TwilightBoxart { };
  powerbar = pkgs.callPackage ./powerbar { };
  tidal-dl-ng = pkgs.callPackage ./tidal-dl-ng { };
  tidal-dl-ng-gui = pkgs.writeShellScriptBin "tidal-dl-ng-gui" ''exec ${tidal-dl-ng}/bin/tidal-dl-ng-gui "$@"'';
}
