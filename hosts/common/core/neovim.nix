{inputs, ...}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    #package = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.neovim-unwrapped;
  };
  environment.variables.EDITOR = "nvim";
}
