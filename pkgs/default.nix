# You can build these directly using 'nix build .#example'
pkgs:
let
  dr_libs = pkgs.callPackage ./dr_libs { };
  bgfx = pkgs.callPackage ./bgfx { };
  bgfx_cmake = pkgs.callPackage ./bgfx_cmake { };
  imgui_cmake = pkgs.callPackage ./imgui_cmake { };
in
{
  inherit dr_libs bgfx bgfx_cmake imgui_cmake;

  bitwarden-rofi = pkgs.callPackage ./bitwarden-rofi { };
  bose-connect-app-linux = pkgs.callPackage ./bose-connect-app-linux { };
  host-lookup = pkgs.callPackage ./host-lookup { };
  openblack = pkgs.callPackage ./openblack {
    inherit dr_libs bgfx bgfx_cmake imgui_cmake;
  };
  TwilightBoxart = pkgs.callPackage ./TwilightBoxart { };
}
