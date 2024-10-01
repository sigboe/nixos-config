{ pkgs
, config
, lib
, configVars
, configLib
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{

  config =
      {
        sops.secrets.sigurdb-password.neededForUsers = true;

        home-manager.users.${configVars.username} = import ../../../../home/${configVars.username}/${config.networking.hostName}.nix;

        users.mutableUsers = false;
        users.users.${configVars.username} = {
          home = "/home/${configVars.username}";
          isNormalUser = true;
          description = "Sigurd Bøe";
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
            ];

          # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
          openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

          shell = pkgs.zsh; # default shell
        };
      };
}
