{ ... }: {
  imports = [
    # All users
    ../common/core
    ../common/optional/firefox.nix
    ../common/optional/kitty.nix
    ../common/optional/nix-index-database.nix


    # Personal
    ./common/core
    ./common/optional/swaync.nix
    ./common/optional/mpv.nix
    ./common/optional/services/waybar
    ./common/optional/sway
  ];

  home.stateVersion = "24.05";
}
