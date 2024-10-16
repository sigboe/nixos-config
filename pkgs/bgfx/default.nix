{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, cmake
, libX11
, libGLU
}:
stdenv.mkDerivation rec {
  pname = "bgfx";
  version = "1.128.8817";
  # From bgfx.cpp source:
  # bgfx 1.104.7082
  #      ^ ^^^ ^^^^
  #      | |   +--- Commit number  (https://github.com/bkaradzic/bgfx / git rev-list --count HEAD)
  #      | +------- API version    (from https://github.com/bkaradzic/bgfx/blob/master/scripts/bgfx.idl#L4)
  #      +--------- Major revision (always 1)
  #
  # api="$(sed '4q;d' scripts/bgfx.idl  | sed 's,version(,,g' | sed 's,),,g')"
  # printf "1.%s.%s" $api "$(git rev-list --count HEAD)"

  srcs = [
    (fetchFromGitHub {
      name = pname;
      owner = "bkaradzic";
      repo = "bgfx";
      rev = "dd4199bcb37426326e0e31419e99c10701e96c58";
      sha256 = "sha256-f1CI/H9nW54Q+sYRfSPHmoMmpRipl+IfgUW/GDAKbv8=";
    })
    (fetchFromGitHub {
      name = "bimg";
      owner = "bkaradzic";
      repo = "bimg";
      rev = "aaf9125234e657393f504404a279289669d89fcb";
      sha256 = "sha256-ru1pjNpEujzfs/UEZTRrZO3EqFVsZuHeN6hCmjrFtxM=";
    })
    (fetchFromGitHub {
      name = "bx";
      owner = "bkaradzic";
      repo = "bx";
      rev = "34d2948860497de1d55e296ec7c213d550fa28d8";
      sha256 = "sha256-yh4dVckpddky2enMHN8/PqUAMDkRjlRq9YOpvzgdiVw=";
    })
  ];
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook cmake libX11 libGLU ];

  dontAutoPatchelf = true;

  patchPhase = ''
    chmod +w bx/tools/bin/linux/genie
    autoPatchelf bx/tools/bin/linux/genie
  '';

  configurePhase = ''
    pushd bgfx
    ../bx/tools/bin/linux/genie --os=linux --platform=x64 --with-tools --with-shared-lib --gcc=linux-gcc gmake
    popd
  '';

  buildPhase = ''
    make -R -C bgfx/.build/projects/gmake-linux config=release64
  '';

  installPhase = ''
    mkdir -p $out/{lib,include,bin}
    install -D bgfx/.build/linux64_gcc/bin/libbgfx-shared-libRelease.so $out/lib/libbgfx.so

    for PROJ in bx bimg bgfx; do
      cp -r $PROJ/include $out/
    done

    install -m644 bgfx/src/bgfx_shader.sh  $out/include/bgfx/
    install -m644 bgfx/src/bgfx_compute.sh $out/include/bgfx/

    for BIN in geometryc geometryv shaderc texturec texturev; do
      install -D bgfx/.build/linux64_gcc/bin/''${BIN}Release $out/bin/bgfx-$BIN
    done

    rm -rf $out/include/compat
    rm -rf $out/include/tinystl
  '';

  meta = with lib; {
    description = ''Cross-platform, graphics API agnostic, "Bring Your Own Engine/Framework" style rendering library.'';
    homepage = "https://github.com/bkaradzic/bgfx.cmake";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sigurdb ];
    platforms = platforms.linux;
  };
}
