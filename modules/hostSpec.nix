# Specifications For Differentiating Hosts
{ config
, lib
, ...
}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    description = "Attribute set of anything";
  };

  config = {
    assertions =
      let
        # We import these options to HM and NixOS, so need to not fail on HM
        isImpermanent =
          config ? "system" && config.system ? "impermanence" && config.system.impermanence.enable;
      in
      [
        {
          assertion = !isImpermanent || (isImpermanent && "${config.hostSpec.persistFolder}" != "");
          message = "config.system.impermanence.enable is true but no persistFolder path is provided";
        }
      ];
  };
}
