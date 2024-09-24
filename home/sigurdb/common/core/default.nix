{ outputs
, configLib
, ...
}: {
  imports = (configLib.scanPaths ./.) ++ (builtins.attrValues outputs.homeManagerModules);
}
