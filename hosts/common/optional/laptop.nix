{ pkgs, ... }: {

  services = {
    # Better scheduling for CPU cycles - thanks System76!!!
    system76-scheduler.settings.cfsProfiles.enable = true;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    # Disable GNOMEs power management
    power-profiles-daemon.enable = false;

    # Enable thermald (only necessary if on Intel CPUs)
    thermald.enable = pkgs.stdenv.hostPlatform == "x86_64-linux";

  };

  # Enable powertop
  powerManagement.powertop.enable = true;

}
