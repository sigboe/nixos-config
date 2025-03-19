{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "overload(ctrl, esc)";
      };
    };
  };
  users.groups.keyd = {};
}
