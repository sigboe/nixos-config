{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl538Packages,
}: let
  perlDeps = with perl538Packages; [
    Clone
    DataDump
    ExporterTiny
    HTTPDate
    HTTPMessage
    JSON
    LWP
    LWPProtocolHttps
    ListMoreUtils
    TextCSV
    TryTiny
    URI
    TimeDate
    EncodeLocale
    IOHTML
    LWPMediaTypes
    FileListing
    HTMLParser
    HTTPCookies
    HTTPCookieJar
    HTTPNegotiate
    NetHTTP
    WWWRobotRules
    IOSocketSSL
    ExporterTiny
    ListMoreUtilsXS
    HTMLTagset
    MozillaCA
    NetSSLeay
  ];
in
  stdenv.mkDerivation rec {
    pname = "host-lookup";
    version = "2020-03-04";

    src = ./host-lookup;

    nativeBuildInputs = [makeWrapper];
    buildInputs = [perl538Packages.perl];

    unpackPhase = ":";

    installPhase = ''
      mkdir -p  $out/bin
      cp ${src} $out/bin/host-lookup
      chmod +x  $out/bin/host-lookup

      # Setup perl path
      wrapProgram $out/bin/host-lookup \
        --set PERL5LIB ${perl538Packages.makePerlPath perlDeps}

      # Symlinks with other functions
      ln -s $out/bin/host-lookup $out/bin/wcssh
      ln -s $out/bin/host-lookup $out/bin/wdsh
      ln -s $out/bin/host-lookup $out/bin/wpdsh
      ln -s $out/bin/host-lookup $out/bin/hosts
    '';

    meta = with lib; {
      description = "This program looks up project handles, team names, or *aas UUIDs in CMDB host lists, limits said lists by values of puppet facts, and executes a given action on the resulting host lists.";
      homepage = "https://redpill-linpro.com";
      license = licenses.mit;
      maintainers = with maintainers; [sigurdb];
      platforms = platforms.linux;
    };
  }
