{ lib
, pkgs
, makeWrapper
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "powerbar";
  version = "v1.0.1.10";

  src = fetchFromGitHub {
    owner = "adamveld12";
    repo = pname;
    rev = "c021bd0e565a0944bb1b5c9ed2b18e7728e903f2";
    sha256 = "sha256-60nwSqHkbScAexrKBHEf/4D0rlL5ScifxKViWW/+AN4=";
  };

  vendorHash = "sha256-wU5Kh4YX0CKRfwH4U0EjwgQOJgrU90BzsxmY8NKMJoY=";
  libPath = lib.makeLibraryPath [ pkgs.dbus ];
  nativeBuildInputs = [ makeWrapper pkgs.dbus ];

  postInstall = ''
    wrapProgram $out/bin/powerbar \
      --set LD_LIBRARY_PATH ${libPath} \
      --set DBUS_SYSTEM_BUS_ADDRESS "unix:path=/run/user/\$(id -u)/bus"
  '';

  meta = with lib; {
    homepage = "https://github.com/adamveld12/powerbar";
    description = "A battery status module for waybar";
    license = licenses.gpl3;
  };
}
