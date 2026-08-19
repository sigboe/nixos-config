{ pkgs, ... }:
{
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;

    buildMachines = [
      {
        inherit (pkgs.stdenv.hostPlatform) system;
        hostName = "bulul.local";
        sshUser = "remotebuild";
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
    ];
  };
}
