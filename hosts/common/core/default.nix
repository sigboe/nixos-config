{
  inputs,
  configLib,
  ...
}: {
  imports =
    (configLib.scanPaths ./.)
    ++ [inputs.home-manager.nixosModules.home-manager];
}
