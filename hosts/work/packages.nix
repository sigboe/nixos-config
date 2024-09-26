{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    openldap
    awscli2
    cloudflare-warp
    openfortivpn
    google-cloud-sdk
  ];
}
