{ lib, inputs, pkgs, ... }: {
  imports = [
    # All users
    ../common/core
    (import ../common/optional/firefox.nix { isDefault = false; inherit lib; })
    (import ../common/optional/zen-browser.nix { isDefault = true; inherit lib inputs pkgs; })
    ../common/optional/kitty.nix
    ../common/optional/ghostty.nix
    ../common/optional/nix-index-database.nix


    # Personal
    ./common/core
    ./common/optional/swaync.nix
    ./common/optional/mpv.nix
    ./common/optional/services/waybar
    ./common/optional/sway
    ./common/optional/sway/kanshi.nix
  ];

  home.stateVersion = "25.05";
}
