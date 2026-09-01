{ config, pkgs, ... }:
{
  sops.secrets.remoteBuild-ssk-key.neededForUsers = true;
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;

    buildMachines = [
      {
        inherit (pkgs.stdenv.hostPlatform) system;
        hostName = "bulul.local";
        sshUser = "remotebuild";
        sshKey = config.sops.secrets.remoteBuild-ssk-key.path;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
    ];
  };
}
