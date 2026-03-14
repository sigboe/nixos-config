{ isDefault ? false, inputs, pkgs, ... }: {
  stylix.targets.zen-browser.profileNames = [ "default" ];
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = isDefault;
    policies =
      {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PictureInPicture.Enabled = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    profiles.default = {
      settings = {
        "media.webrtc.camera.allow-pipewire" = true;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "privacy.webrtc.legacyGlobalIndicator" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        bitwarden
        clearurls
        darkreader
        dearrow
        duckduckgo-privacy-essentials
        istilldontcareaboutcookies
        linkwarden
        privacy-badger
        sponsorblock
        ublock-origin
      ];
    };
  };
}
