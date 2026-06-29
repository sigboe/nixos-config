{ isDefault ? false, inputs, pkgs, lib, config, ... }: {
  stylix.targets.firefox.profileNames = [ "default" ];
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
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
    languagePacks = [
      "en-US"
      "nb-NO"
    ];
    profiles.default = {
      search.default = "ddg";
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
} // lib.optionalAttrs isDefault {
  xdg.mimeApps.defaultApplications = {
    "application/x-extension-htm" = [ "firefox.desktop" ];
    "application/x-extension-html" = [ "firefox.desktop" ];
    "application/x-extension-shtml" = [ "firefox.desktop" ];
    "application/x-extension-xht" = [ "firefox.desktop" ];
    "application/x-extension-xhtml" = [ "firefox.desktop" ];
    "application/xhtml+xml" = [ "firefox.desktop" ];
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/chrome" = [ "firefox.desktop" ];
    "x-scheme-handler/ftp" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
