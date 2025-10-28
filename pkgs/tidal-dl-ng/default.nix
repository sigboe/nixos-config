{ lib
, fetchFromGitHub
, python3
, makeDesktopItem
, copyDesktopItems
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tidal-dl-ng";
  version = "0.31.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "exislow";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a1p8niy7f457s53yfcv2vyga6zdl4vdddh5bzh2pjkmgimg8i1x";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    copyDesktopItems
  ];

  
  pythonRelaxDeps = [
    "rich"
    "typer"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # Add dependencies from pyproject.toml [tool.poetry.dependencies]
    requests
    mutagen
    dataclasses-json
    pathvalidate
    m3u8
    coloredlogs
    pyside6
    #pyqtdarktheme-fork
    pyqtdarktheme
    rich
    toml
    typer
    tidalapi
    python-ffmpeg
    pycryptodome
    ansi2html
  ];

  postInstall = ''
    for size in 16 32 48 64 256 512; do
      install -Dm644 tidal_dl_ng/ui/icon''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/tidal-dl-ng.png
    done
        '';

  desktopItems = [
    (makeDesktopItem {
      name = "tidal-dl-ng";
      desktopName = "TIDAL Downloader NG";
      comment = "Download TIDAL music in high quality";
      exec = "tidal-dl-ng-gui";
      icon = "tidal-dl-ng";
      categories = [ "AudioVideo" "Audio" ];
      keywords = [ "tidal" "music" "download" "hires" ];
    })
  ];


  # Poetry projects often have issues with tests in Nix
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/exislow/tidal-dl-ng";
    description = "Multithreaded TIDAL Media Downloader Next Generation! Up to HiRes Lossless / TIDAL MAX 24-bit, 192 kHz and Dolby Atmos.";
    license = licenses.agpl3Only;
    mainProgram = "tidal-dl-ng";
  };
}
