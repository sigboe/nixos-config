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
            position = "3340,800";
          }
          {
            criteria = ''output "GIGA-BYTE TECHNOLOGY CO., LTD. M34WQ FP0@:'';
            status = "enable";
            mode = "3440x1440@59.973Hz";
            position = "0,0";
          }
        ];
      }
    ];
  };
}
