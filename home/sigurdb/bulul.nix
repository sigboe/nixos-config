{ config, lib, inputs, pkgs, ... }: {
  imports = [
    # All users
    ../common/core
    ../common/optional/kitty.nix
    ../common/optional/ghostty.nix
    ../common/optional/nix-index-database.nix


    # Personal
    ./common/core
  ];

  home.stateVersion = "26.05";
}
