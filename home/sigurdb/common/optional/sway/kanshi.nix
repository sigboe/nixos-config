{
  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      };
      homeOffice = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "3340,800";
          }
          {
            criteria = ''GIGA-BYTE TECHNOLOGY CO., LTD. M34WQ \xa0FP0@:'';
            status = "enable";
            mode = "3440x1440@59.973Hz";
            position = "0,0";
          }
        ];
      };
    };
  };
}
