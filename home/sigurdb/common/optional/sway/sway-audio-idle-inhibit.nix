{ pkgs, ... }: {
  systemd.user.services.sway-audio-idle-inhibit = {
    Unit = {
      Description = "Sway Audio Idle Inhibit";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
