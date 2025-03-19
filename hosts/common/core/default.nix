{
  inputs,
  lib,
  ...
}: {
  imports =
    (lib.custom.scanPaths ./.)
    ++ [inputs.home-manager.nixosModules.home-manager];
}
