{ config, lib, ... }:
let
  inherit (config) hostSpec;
in
{
  services.hostapd = {
    enable = true;
    radios = {
      wlan0 = {
        band = "5g";
        channel = 36;
        countryCode = "NO";
        networks.wlan0 = {
          inherit (hostSpec.hostapd.radios.wlan0.networks.wlan0) ssid;
          authentication = {
            inherit (hostSpec.hostapd.radios.wlan0.networks.wlan0.authentication) wpaPassword;
            mode = "wpa2-sha256";
          };
        };
      };
    };
  };
}
