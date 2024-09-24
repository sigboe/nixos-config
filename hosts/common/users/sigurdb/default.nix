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
  # these are values we don't want to set if the environment is minimal. E.g. ISO or nixos-installer
  # isMinimal is true in the nixos-installer/flake.nix
  fullUserConfig = lib.optionalAttrs (!configVars.isMinimal) {
    users.users.${configVars.username} = {
      #hashedPasswordFile = sopsHashedPasswordFile;
      packages = [ pkgs.home-manager ];
    };

    # Import this user's personal/home configurations
    home-manager.users.${configVars.username} = import ../../../../home/${configVars.username}/${config.networking.hostName}.nix;
  };
in
{
  config =
    lib.recursiveUpdate fullUserConfig
      {
        users.users.${configVars.username} = {
          home = "/home/${configVars.username}";
          isNormalUser = true;
          description = "Sigurd Bøe";
          initialHashedPassword = "$y$j9T$2GOTQNGE4LXrNUTqg5Cjt/$vvVeZL2xGlqGF4Oh2aoSFfW5G0TAXz4azWdMumuD5.7";

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
