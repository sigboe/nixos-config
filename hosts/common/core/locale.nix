{ config, ... }: {
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n = {
    supportedLocales = [ "all" ];
    defaultLocale = "nb_NO.utf-8";
    extraLocaleSettings = {
      LANG = "en_US.utf8";
      LC_CTYPE = config.i18n.defaultLocale;
      LC_NUMERIC = config.i18n.defaultLocale;
      LC_TIME = config.i18n.defaultLocale;
      LC_COLLATE = config.i18n.defaultLocale;
      LC_MONETARY = config.i18n.defaultLocale;
      LC_MESSAGES = "en_US.utf8";
      LC_PAPER = config.i18n.defaultLocale;
      LC_NAME = config.i18n.defaultLocale;
      LC_ADDRESS = config.i18n.defaultLocale;
      LC_TELEPHONE = config.i18n.defaultLocale;
      LC_MEASUREMENT = config.i18n.defaultLocale;
      LC_IDENTIFICATION = config.i18n.defaultLocale;
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";
}
