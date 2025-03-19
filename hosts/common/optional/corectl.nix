{ config
, ...
}: {
  programs.corectrl = {
    enable = true;
    gpuOverclock.ppfeaturemask = "0xffffffff";
    gpuOverclock.enable = true;
  };
  users.users.${config.hostSpec.username}.extraGroups = [ "corectrl" ];
}
