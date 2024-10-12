{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  makeWrapper,
  bluez,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bose-connect-app-linux";
  version = "2024-04-09";

  src = fetchFromGitHub {
    owner = "airvzxf";
    repo = "bose-connect-app-linux";
    rev = "2cf59f5d2ba11bbfc4736de0c56601329f003737";
    sha256 = "sha256-sBAfLd1u3+YpFPbiI587tIHq/mUX0Mk9NMQtRsgk25Q=";
  };

  nativeBuildInputs = [pkg-config cmake makeWrapper];

  buildInputs = [bluez];

  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"];

  configurePhase = ''
    cmake -S $src/src -B ./build $cmakeFlags
  '';

  buildPhase = ''
    cmake --build ./build --config Release --parallel "$(nproc)"
  '';

  installPhase = ''
    cmake --install ./build --strip --config Release --prefix $out
  '';

  meta = with lib; {
    description = "Bose® Connect App for Linux [Not Official]";
    homepage = "https://github.com/airvzxf/bose-connect-app-linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [sigurdb];
    mainProgram = "bose-connect-app-linux";
    platforms = platforms.linux;
  };
})
