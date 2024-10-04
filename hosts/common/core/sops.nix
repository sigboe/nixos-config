{ pkgs, inputs, config, configVars, ... }:
let
  secretsDirectory = builtins.toString inputs.nix-secrets;
  secretsFile = "${secretsDirectory}/secrets.yaml";

  #  homeDirectory =
  #    if pkgs.stdenv.isLinux
  #    then "/home/${configVars.username}"
  #    else "/Users/${configVars.username}";
in
{
  sops = {
    defaultSopsFile = "${secretsFile}";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [
        "/persist/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    # Secrets will be output to /run/secrets
    # e.g. /run/secrets/luks-password
    # secrets required for user creation are handled in in the user's .nix file
    #secrets = {
    #  luks-password = {};
    #};
  };
}
