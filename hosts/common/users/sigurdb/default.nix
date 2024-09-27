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
        home-manager.users.${configVars.username} = import ../../../../home/${configVars.username}/${config.networking.hostName}.nix;
        users.users.${configVars.username} = {
          home = "/home/${configVars.username}";
          isNormalUser = true;
          description = "Sigurd Bøe";
          initialHashedPassword = "$y$j9T$cK3m55nJAjOdWpLWKJcns1$pnpTAtJ/nVh2p3uhuA3de2Q5K8Vo6FZPQIxLqhLaarB";

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
