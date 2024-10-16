{ lib
, stdenv
, fetchFromGitHub
, cmake
, libX11
, libGLU
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bgfx_cmake";
  version = "1.128.8808-482";

  src = fetchFromGitHub {
    owner = "bkaradzic";
    repo = "bgfx.cmake";
    fetchSubmodules = true;
    rev = "f531516396e7507f63c0e448543bc6d9bc546191";
    sha256 = "sha256-HCOvX7WQulaLVTGUkrvAv7kDDaFy9siiPAXuQ+4uzzQ=";
  };

  nativeBuildInputs = [ cmake libX11 libGLU ];

  cmakeFlags = [
    "-DBGFX_BUILD_EXAMPLES=OFF"
    "-DBGFX_INSTALL_EXAMPLES=OFF"
    "-DBGFX_CUSTOM_TARGETS=OFF"
    "-DBGFX_LIBRARY_TYPE=SHARED"
    "-DBGFX_TOOLS_PREFIX=bgfx-"
    "-DCMAKE_INSTALL_PREFIX=/usr"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
  ];

  configurePhase = ''
    cmake -S $src -B ./build $cmakeFlags
  '';

  buildPhase = ''
    cmake --build ./build --parallel "$NIX_BUILD_CORES"
  '';

  installPhase = ''
    cmake --install ./build --strip --prefix $out
  '';

  meta = with lib; {
    description = ''Cross-platform, graphics API agnostic, "Bring Your Own Engine/Framework" style rendering library. C++ bindings only'';
    homepage = "https://github.com/bkaradzic/bgfx.cmake";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sigurdb ];
    platforms = platforms.linux;
  };
})
