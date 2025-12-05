{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    winboat
  ];
  virtualisation.docker.enable = true;
  users.users.${config.hostSpec.username}.extraGroups = [ "docker" ];
}
