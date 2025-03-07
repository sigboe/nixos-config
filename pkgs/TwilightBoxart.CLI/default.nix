{ lib
, fetchFromGitHub
, dotnetCorePackages
, buildDotnetModule
}:

buildDotnetModule {
  pname = "TwilightBoxart.CLI";
  version = "v0.8.2";

  src = fetchFromGitHub {
    owner = "MateusRodCosta";
    repo = "TwilightBoxart";
    rev = "528ae3188af24ecf7e8cfe0820afe4868850d205";
    sha256 = "sha256-z3DxP1zZxBfURmnSR+J4Vx1fGet+78/RpZb3qZPfi74=";
  };

  projectFile = "TwilightBoxart.CLI/TwilightBoxart.CLI.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.json;

  meta = with lib; {
    homepage = "https://github.com/MateusRodCosta/TwilightBoxart";
    description = "A boxart downloader written in C#. Uses various sources and scan methods to determine the correct boxart. Written for TwilightMenu++ but can be used for other loader UI's with some config changes.";
    license = licenses.unfree;
  };
}
