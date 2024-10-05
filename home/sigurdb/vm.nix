{ configVars , ... }: {
  imports = [
    ./common/core

    ./common/optional/dunst.nix
    ./common/optional/firefox.nix
    ./common/optional/kitty.nix
    ./common/optional/mpv.nix
    ./common/optional/nix-index-database.nix
    ./common/optional/services/waybar
    ./common/optional/sway
  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };

  home.stateVersion = "24.05";
}
