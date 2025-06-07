{ ... }: {
  imports = [
    # All users
    ../common/core
    ../common/optional/kitty.nix
    ../common/optional/nix-index-database.nix


    # Personal
    ./common/core
    ./common/optional/mpv.nix
  ];

  home.stateVersion = "24.11";
}
