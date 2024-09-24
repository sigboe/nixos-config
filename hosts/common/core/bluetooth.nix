{
  inputs,
  pkgs,
  ...
}: {
  # Bluetooth
  hardware = {
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings.General.Experimental = true; # Bluetooth headset battery reporting
    };
    # enableAllFirmware = true;
    # enableRedistributableFirmware = true;
  };
  services.blueman.enable = true;
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = ["network.target" "sound.target"];
    wantedBy = ["default.target"];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
}
