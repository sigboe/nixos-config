{ lib, ... }: {
  imports = [
    # All users
    ../common/core
    (import ../common/optional/firefox.nix { isDefault = true; inherit lib; })
    ../common/optional/kitty.nix
    ../common/optional/nix-index-database.nix
    ../common/optional/nextcloud-client.nix

    # Personal
    ./common/core
  ];

  home.stateVersion = "24.11";
}
