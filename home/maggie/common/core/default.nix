{ configLib, ... }: {
  imports = configLib.scanPaths ./.;
}
