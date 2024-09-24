{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
}
