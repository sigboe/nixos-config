{ config, ... }: {
  imports = [
    # All users
    ../common/core
    ../common/optional/firefox.nix
    ../common/optional/kitty.nix
    ../common/optional/nix-index-database.nix

    # Personal
    ./common/core
  ];

  home.stateVersion = "24.11";
}
