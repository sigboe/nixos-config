{ lib, pkgs, inputs, ... }:

let
  t3-code =
    inputs.t3code-flake.packages.${pkgs.stdenv.hostPlatform.system}.t3-code.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgramShell "$out/bin/t3code" \
          --run 'export T3CODE_HOME="$HOME/.config/t3"' \
          --set T3CODE_DESKTOP_LAUNCHER_PATH "$out/bin/t3code"
        wrapProgramShell "$out/bin/t3" \
          --run 'export T3CODE_HOME="$HOME/.config/t3"'
        substituteInPlace "$out/share/applications/t3-code.desktop" \
          --replace-fail 'Exec=t3code %U' "Exec=$out/bin/t3code %U"
      '';
    });
in
{
  environment.systemPackages = with pkgs; [
    opencode
    claude-code
    opencode-claude-auth
    inputs.codex-nix.packages.${pkgs.system}.default
    rtk
    nodejs_26
    mcp-nixos
    t3-code
  ];

  networking.firewall.allowedTCPPorts = [
    49374
    4096
    3773
  ];

  systemd.user.services.t3code = {
    description = "T3 Code server";
    enable = lib.mkDefault false;
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];

    path = with pkgs; [
      claude-code
      git
      openssh
      nodejs_26
      rtk
      inputs.codex-nix.packages.${pkgs.system}.default
    ];

    serviceConfig = {
      ExecStart = "${t3-code}/bin/t3 serve --host 0.0.0.0 --port 3773";
      Environment = "T3CODE_HOME=%h/.config/t3";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
