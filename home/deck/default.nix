{ lib, inputs, pkgs, ... }: {
  imports = [
    # All users
    ../common/core
    ../common/optional/kitty.nix
    ../common/optional/nix-index-database.nix


    # Personal
    ./common/core
    ./common/optional/card-forge.nix
  ];

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "25.11";
  };
}
