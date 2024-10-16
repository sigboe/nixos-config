{ lib, stdenv, fetchFromGitHub, copyPkgconfigItems, makePkgconfigItem }:

stdenv.mkDerivation rec {
  pname = "dr_libs";
  version = "unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "da35f9d6c7374a95353fd1df1d394d44ab66cf01";
    sha256 = "sha256-ydFhQ8LTYDBnRTuETtfWwIHZpRciWfqGsZC6SuViEn0=";
  };

  nativeBuildInputs = [ copyPkgconfigItems ];

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "dr_libs";
      version = "1";
      cflags = [ "-I${variables.includedir}/dr_libs" ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
      };
      inherit (meta) description;
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include/dr_libs
    cp *.h $out/include/dr_libs/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Audio decoding libraries for C/C++, each in a single source file.";
    homepage = "https://github.com/mackron/dr_libs";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ sigurdb ];
  };
}
