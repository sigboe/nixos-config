{ config, lib, ... }: {
  imports = lib.custom.scanPaths ./.;
  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
  };
}
