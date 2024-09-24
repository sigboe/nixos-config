{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    awscli2
    cloudflare-warp
    openfortivpn
    google-cloud-sdk
  ];
}
