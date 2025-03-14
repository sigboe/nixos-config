{ pkgs
, config
, lib
, configVars
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{
  config = {
    sops.secrets = {
      sigurdb-password.neededForUsers = true;
      sigurdb-name.neededForUsers = true;
    };

    home-manager.users.${configVars.username} = import ../../../../home/${configVars.username}/${config.networking.hostName}.nix;

    users.mutableUsers = false;
    users.users.${configVars.username} = {
      home = "/home/${configVars.username}";
      isNormalUser = true;
      description = config.sops.secrets.sigurdb-name.key;
      hashedPasswordFile = config.sops.secrets.sigurdb-password.path;

      extraGroups =
        [ "wheel" ]
        ++ ifTheyExist [
          "audio"
          "video"
          "docker"
          "git"
          "networkmanager"
          "corectrl"
          "dialout"
        ];

      # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
      openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

      shell = pkgs.zsh; # default shell
    };
  };
}
