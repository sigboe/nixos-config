{ secretsFilename ? throw "example sigurdb-secrets", config, lib, inputs, ... }:
let
  secretsDirectory = builtins.toString inputs.nix-secrets;
  secretsFile = "${secretsDirectory}/${secretsFilename}.yaml";
in
{
  sops = {
    defaultSopsFile = "${secretsFile}";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = lib.mkDefault [
        "/persist/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = lib.mkDefault "/persist/var/lib/sops-nix/key.txt";
      generateKey = lib.mkDefault true;
    } // lib.optionalAttrs (config.environment.persistence == { }) {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = lib.mkDefault true;
    };

  };
}
