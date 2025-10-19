{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      }
      {
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "3440,800";
          }
          {
            # serial contains non-breaking-space this is how kanshi accpets the serial
            # wl-randr and swaymsg -t get_outputs return this with one backspace
            criteria = ''GIGA-BYTE TECHNOLOGY CO., LTD. M34WQ \*'';
            status = "enable";
            mode = "3440x1440@59.973Hz";
            position = "0,0";
          }
        ];
      }
    ];
  };
}
