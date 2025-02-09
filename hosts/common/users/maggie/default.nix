{ pkgs
, config
, lib
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
  username = "maggie";
in
{
  config = {
    sops.secrets = {
      maggie-password.neededForUsers = true;
      maggie-name.neededForUsers = true;
    };

    home-manager.users.${username} = import ../../../../home/${username}/${config.networking.hostName}.nix;

    users.mutableUsers = false;
    users.users.${username} = {
      home = "/home/${username}";
      isNormalUser = true;
      description = config.sops.secrets.maggie-name.key;
      hashedPasswordFile = config.sops.secrets.maggie-password.path;

      extraGroups =
        [ "wheel" ]
        ++ ifTheyExist [
          "audio"
          "video"
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
