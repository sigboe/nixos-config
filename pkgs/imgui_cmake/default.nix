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
      rev = "16601c6e7ee15aeccac771185916cd6f6fe1ba50";
      sha256 = "sha256-x9GNh7EcDdXGZNBSEXXqbflfs4/o+Glnn5wW1k6JCcs=";
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
    cp ../vcpkg/ports/imgui/imgui-config.cmake.in $out/include/imgui/imgui-config.cmake
  '';

  meta = with lib; {
    description = "Bloat-free Graphical User interface for C++ with minimal dependencies. With Cmake config-files";
    homepage = "https://github.com/ocornut/imgui";
    license = licenses.mit;
    maintainers = with maintainers; [ sigurdb ];
    platforms = platforms.all;
  };
}
