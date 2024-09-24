{ configVars
, ...
}: {
  imports = [
    ./common/core

    ./common/optional/nix-index-database.nix
    ./common/optional/dunst.nix
    ./common/optional/kitty.nix
    ./common/optional/firefox.nix
    ./common/optional/sway
    ./common/optional/services/waybar
  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };

  programs.nix-index.enable = true;
  home.stateVersion = "24.05";
}
