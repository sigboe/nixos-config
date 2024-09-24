{
  pkgs,
  configVars,
  ...
}: {
  programs.corectrl = {
    enable = true;
    gpuOverclock.ppfeaturemask = "0xffffffff";
    gpuOverclock.enable = true;
  };
  users.user.${configVars.username}.extraGroups = ["corectrl"];
}
