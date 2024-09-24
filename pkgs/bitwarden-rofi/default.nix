{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  bitwarden-cli,
  gnupg,
  gnused,
  jq,
  keyutils,
  libnotify,
  rofi,
}:
stdenv.mkDerivation rec {
  pname = "bitwarden-rofi";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "mattydebie";
    repo = "bitwarden-rofi";
    rev = "8be76fdd647c2bdee064e52603331d8e6ed5e8e2";
    sha256 = "sha256-jXPwbvUTlMdwd/SYesfMuu7sQgR2WMiKOK88tGcQrcA=";
  };

  buildInputs = [makeWrapper];

  propagatedBuildInputs = [
    bash
    rofi
    jq
    gnused
    bitwarden-cli
    gnupg
    keyutils
    libnotify
  ];
  #optionalDependencies = [xsel xclip wl-clipboard xdotool ydotool];

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bwmenu $out/bin/
    cp ${src}/lib-bwmenu $out/bin/
    chmod +x $out/bin/bwmenu

    # Documentation
    docPath=$out/share/doc/${pname}
    mkdir -p $docPath
    mkdir -p $docPath/img
    cp ${src}/README.md $docPath/
    cp ${src}/img/* $docPath/img/

    # License
    mkdir -p $out/share/licenses/${pname}
    cp ${src}/LICENSE $out/share/licenses/${pname}/
  '';

  meta = with lib; {
    description = "Wrapper for Bitwarden-cli and Rofi";
    homepage = "https://github.com/mattydebie/bitwarden-rofi";
    license = licenses.gpl3;
    maintainers = with maintainers; [sigurdb];
    platforms = platforms.linux;
  };
}
