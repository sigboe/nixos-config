{
  #Avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings.publish = {
      enable = true;
      userServices = true;
    };
  };
}
