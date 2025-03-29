{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openldap
    awscli2
    cloudflare-warp
    openfortivpn
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
        config-connector
        local-extract
      ]
    ))
  ];
}
