{ config, pkgs, ... }:
{
  programs.ssh.knownHosts.bulul = {
    hostNames = [ "bulul" "bulul.local" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/gdfXHjYhhzJP1nBhGQoFbvll0DztHHf8jH3QGG+Oo";
  };

  sops.secrets.remoteBuild-ssk-key.neededForUsers = true;
  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;

    buildMachines = [
      {
        inherit (pkgs.stdenv.hostPlatform) system;
        systems = [
          "x86_64-linux"
          "i686-linux"
        ];
        hostName = "bulul.local";
        sshUser = "remotebuild";
        sshKey = config.sops.secrets.remoteBuild-ssk-key.path;
        supportedFeatures = [ "nixos-test" "big-parallel" "kvm" ];
      }
    ];
  };
}
