{ isDefault ? false, lib, inputs, pkgs, ... }: {
  stylix.targets.zen-browser.profileNames = [ "default" ];
  programs.zen-browser = {
    enable = true;
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
} // lib.optionalAttrs isDefault {
  xdg.mimeApps =
    let
      value =
        let
          zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
        in
        zen-browser.meta.desktopFileName;

      associations = builtins.listToAttrs (map
        (name: {
          inherit name value;
        }) [
        "application/json"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/x-extension-xht"
        "application/x-extension-xhtml"
        "application/xhtml+xml"
        "text/html"
        "text/plain"
        "x-scheme-handler/about"
        "x-scheme-handler/chrome"
        "x-scheme-handler/ftp"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
        "x-scheme-handler/unknown"
      ]);
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };

}
