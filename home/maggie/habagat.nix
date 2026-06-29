{ config, lib, inputs, pkgs, ... }: {
  imports = [
    # All users
    ../common/core
    (import ../common/optional/firefox.nix { isDefault = true; inherit config lib inputs pkgs; })
    ../common/optional/kitty.nix
    ../common/optional/nix-index-database.nix
    ../common/optional/nextcloud-client.nix

    # Personal
    ./common/core
  ];

  home.stateVersion = "25.11";
}
