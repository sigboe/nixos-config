{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    yubico-pam
    yubikey-manager
    yubikey-touch-detector
    yubioath-flutter
  ];
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];
}
