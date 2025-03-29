{ host, lib, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = true;
      # It's still possible to open the bootloader list by pressing any key
      timeout = 1;
    };
  } // lib.optionalAttrs (!lib.hasSuffix "-bootstrap" host) {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
