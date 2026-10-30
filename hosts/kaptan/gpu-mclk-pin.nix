# RX 560 (Polaris) at 3440x1440@144: after S3 resume amdgpu starts switching
# mclk (625 <-> 1500 MHz) while scanning out, which underflows the display ->
# coloured snow at the top of the screen, worse when the mouse moves.
# Confirmed 2026-10-30: power_dpm_force_performance_level=high makes it go away.
# Pin only mclk to its top level; sclk stays dynamic. Re-applied after resume.
# Resume-only bug: fresh boot keeps mclk at 1500 by itself; after S3 it idles at 300.
{ pkgs, ... }:
let
  pinMclk = pkgs.writeShellScript "gpu-pin-mclk" ''
    for dev in /sys/class/drm/card*/device; do
      [ "$(cat "$dev/vendor" 2>/dev/null)" = 0x1002 ] || continue
      [ -w "$dev/pp_dpm_mclk" ] || continue
      top=$(${pkgs.gnused}/bin/sed -n '$s/:.*//p' "$dev/pp_dpm_mclk")
      echo manual > "$dev/power_dpm_force_performance_level"
      echo "$top" > "$dev/pp_dpm_mclk"
    done
  '';
in
{
  systemd.services.gpu-pin-mclk = {
    description = "Pin amdgpu memory clock (Polaris high-res scanout underflow)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pinMclk;
    };
  };
  # Pinning right at resume (powerManagement.resumeCommands) gets undone a moment
  # later, presumably by the display re-modeset; pinning again by hand works.
  # So re-pin a few times after the display has settled.
  systemd.services.gpu-pin-mclk-resume = {
    description = "Re-pin amdgpu memory clock after resume";
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for delay in 2 3 10; do
        sleep "$delay"
        ${pinMclk}
      done
    '';
  };
}
