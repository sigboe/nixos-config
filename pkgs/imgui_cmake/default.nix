{ stdenv, lib, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "imgui_cmake";
  version = "1.91.3";

  srcs = [
    (fetchFromGitHub {
      name = pname;
      owner = "ocornut";
      repo = "imgui";
      rev = "v${version}";
      sha256 = "sha256-J4gz4rnydu8JlzqNC/OIoVoRcgeFd6B1Qboxu5drOKY=";
    })
    (fetchFromGitHub {
      name = "vcpkg";
      owner = "microsoft";
      repo = "vcpkg";
      rev = "f7a371bbd9945c9059875492ba018ec12cb925c2";
      sha256 = "sha256-kJXqPWjycd4lGMbmlN7ykbeOTmfoQTvOgEXBu+fLZWU=";
    })
  ];
  sourceRoot = pname;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include/imgui

    cp *.h $out/include/imgui
    cp *.cpp $out/include/imgui
    cp -a backends $out/include/imgui/
    cp -a misc $out/include/imgui/
    cp ../vcpkg/ports/imgui/CMakeLists.txt $out/include/imgui
    cp ../vcpkg/ports/imgui/imgui-config.cmake.in $out/include/imgui
  '';

  meta = with lib; {
    description = "Bloat-free Graphical User interface for C++ with minimal dependencies. With Cmake config-files";
    homepage = "https://github.com/ocornut/imgui";
    license = licenses.mit;
    maintainers = with maintainers; [ sigurdb ];
    platforms = platforms.all;
  };
}
