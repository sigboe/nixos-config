{ pkgs, lib, ... }: {
  services = {
    printing = {
      enable = true;
      #drivers = [ pkgs.hplipWithPlugin ];
    };
    avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
      openFirewall = lib.mkDefault true;
    };
  };
  hardware.sane = {
    enable = true;
    #extraBackends = [ pkgs.hplipWithPlugin ];
  };
  #environment.systemPackages = [ pkgs.hplipWithPlugin ];
}
