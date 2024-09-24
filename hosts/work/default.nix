{
  inputs,
  outputs,
  configLib,
  ...
}: {
  imports =
    (configLib.scanPaths ./.)
    ++ [inputs.home-manager.nixosModules.home-manager]
    ++ (builtins.attrValues outputs.nixosModules);
}
