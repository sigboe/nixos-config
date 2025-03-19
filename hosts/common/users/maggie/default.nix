{ config
, lib
, pkgs
, ...
}:
let
  inherit (config) hostSpec;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{
  config = {
    sops.secrets."${hostSpec.username}-password".neededForUsers = true;

    home-manager.users.${hostSpec.username} = import ../../../../home/${hostSpec.username}/${hostSpec.hostName}.nix;

    users.mutableUsers = false;
    users.users.${hostSpec.username} = {
      home = "/home/${hostSpec.username}";
      isNormalUser = true;
      inherit (hostSpec) description openssh;
      hashedPasswordFile = config.sops.secrets."${hostSpec.username}-password".path;

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

      shell = pkgs.zsh; # default shell
    };
  };
}
