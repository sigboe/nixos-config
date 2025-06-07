{ config
, host
, lib
, pkgs
, ...
}:
let
  inherit (config) hostSpec;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  config = {
    home-manager.users.${hostSpec.username} = import ../../../home/${hostSpec.username}/${hostSpec.hostName}.nix;

    users.mutableUsers = true;
    users.users.${hostSpec.username} = {
      home = "/home/${hostSpec.username}";
      isNormalUser = true;
      initialHashedPassword = "$6$4Ul8eoDrKNxlne2s$.K98AW8Cn0gJyfgQbmRTU.XdXxMQB1jP/cNKnmuKucKQLFu1ovMz5Zjinxs/Kv.TE4wxwaus6KI53SGNmBPnO1";

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
  } // lib.optionalAttrs (!lib.hasSuffix "-bootstrap" host) { };
}
