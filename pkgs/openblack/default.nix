{ lib
, stdenv
, fetchFromGitHub
, cmake
, spdlog
, entt
, SDL2
, glm
, bullet
, minizip
, pkg-config
, imgui_cmake
, openal
, cxxopts
, stb
, utf8cpp
, dr_libs
, bgfx
, bgfx_cmake
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openblack";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "openblack";
    repo = "openblack";
    fetchSubmodules = true;
    rev = "f393be3de149c7b38c3047ed9adec4e53efc85dd";
    sha256 = "sha256-JHKZccznq2k5+tVdaOXv6Wum/wwvcjBKfU9xzVuFJaU=";
  };

  # Build dependencies
  nativeBuildInputs = [ cmake cxxopts stb utf8cpp dr_libs imgui_cmake bgfx_cmake minizip pkg-config ];

  # Runtime dependencies
  buildInputs = [ spdlog entt SDL2 glm bgfx bullet minizip imgui_cmake openal ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=/"
    "-DOPENBLACK_USE_BUNDLED_BGFX=OFF"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DStb_INCLUDE_DIR=/include/stb"
    "-DDRLIBS_INCLUDE_DIRS=/include/dr_libs"
  ];

  configurePhase = ''
    cmake -S $src -B ./build $cmakeFlags
  '';

  buildPhase = ''
    cmake --build $src/build --config Release --parallel "$NIX_BUILD_CORES"
  '';

  installPhase = ''
    cmake --install $src/build --strip --config Release --prefix $out
  '';

  meta = with lib; {
    description = "openblack is an open-source game engine that supports playing Black & White (2001).";
    homepage = "https://github.com/openblack/openblack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sigurdb ];
    mainProgram = "openblack";
    platforms = platforms.linux;
  };
})
