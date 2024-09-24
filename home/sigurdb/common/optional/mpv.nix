{pkgs, ...}: {
  programs.mpv = {
    config = {
      hwdec = "auto";
      fs = false;
      geometry = "50%:50%";
      video-sync = "display-resample";
      interpolation = true;
      blend-subtitles = true;
      tscale = "oversample";
      profile = "gpu-hq";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      af = "scaletempo";
      audio-display = false;
      cache = true;
      demuxer-max-bytes = "512M";
      demuxer-max-back-bytes = "128M";
      osc = false;
      screenshot-directory = "~/Pictures";
    };
    scripts = with pkgs.mpvScripts; [
      sponsorblock-minimal
      uosc
    ];
  };
}
