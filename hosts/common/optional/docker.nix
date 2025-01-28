{ pkgs, ... }:
{
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Enable the ability to run arm docker images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  # If you add to this list, or have used podman before setting this option, you might have to run
  # sudo podman run --rm --privileged multiarch/qemu-user-static --reset -p yes

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    podman-compose # start group of containers for dev
    lazydocker # maybe make a wrapper that sets DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
    distrobox
  ];
}
