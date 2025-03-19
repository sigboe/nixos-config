{
  inputs,
  lib,
  outputs,
  ...
}: {
  imports =
    (lib.custom.scanPaths ./.)
    ++ [inputs.home-manager.nixosModules.home-manager]
    ++ (builtins.attrValues outputs.nixosModules);
}
