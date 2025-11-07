{ config, lib, pkgs, ... }:
{
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
    docker.enable = true;
  };

  # Enable the ability to run arm docker images
  boot.binfmt.emulatedSystems = lib.optionals (pkgs.stdenv.hostPlatform == "x86_64-linux") [ "aarch64-linux" "armv7l-linux" ];
  # If you add to this list, or have used docker before setting this option, you might have to run
  # sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    docker-compose # start group of containers for dev
    lazydocker
    distrobox
  ];

  users.users.${config.hostSpec.username}.extraGroups = [ "docker" ];

}
