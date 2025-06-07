{ isDefault ? false, config, lib, inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages."${system}".twilight
  ];
} // lib.optionalAttrs isDefault {
  home-manager.users.${config.hostSpec.username}.xdg.mimeApps.defaultApplications = {
    "application/x-extension-htm" = [ "zen-twilight.desktop" ];
    "application/x-extension-html" = [ "zen-twilight.desktop" ];
    "application/x-extension-shtml" = [ "zen-twilight.desktop" ];
    "application/x-extension-xht" = [ "zen-twilight.desktop" ];
    "application/x-extension-xhtml" = [ "zen-twilight.desktop" ];
    "application/xhtml+xml" = [ "zen-twilight.desktop" ];
    "text/html" = [ "zen-twilight.desktop" ];
    "x-scheme-handler/chrome" = [ "zen-twilight.desktop" ];
    "x-scheme-handler/ftp" = [ "zen-twilight.desktop" ];
    "x-scheme-handler/http" = [ "zen-twilight.desktop" ];
    "x-scheme-handler/https" = [ "zen-twilight.desktop" ];
  };
}
