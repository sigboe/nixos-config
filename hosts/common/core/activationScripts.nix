{ pkgs, self, config, ... }: {
  system.activationScripts = {
    gitcommit.text = ''
      if "${pkgs.systemd}/bin/systemctl" is-system-running -q; then
        etcNixos="$(readlink -f /etc/nixos)"
        owner="$(stat -c '%U' $etcNixos)"
        hostName="${config.networking.hostName}"
        internalOutPath="${self.sourceInfo.outPath}"
        PATH="/run/current-system/sw/bin" etcNixosOutPath="$(sudo -u $owner "${pkgs.nix}/bin/nix" flake metadata --json "$etcNixos" | "${pkgs.jq}/bin/jq" -r .path)"

        if [ "$internalOutPath" == "$etcNixosOutPath" ] && \
        sudo -u $owner "${pkgs.git}/bin/git" -C "$etcNixos" rev-parse --is-inside-work-tree
        then
          nameStatus="$(sudo -u "$owner" "${pkgs.git}/bin/git" -C "$etcNixos" diff --name-status --diff-filter=DM)"
          metadata="$("${pkgs.nixos-rebuild}/bin/nixos-rebuild" list-generations --json)"
          gen="$("${pkgs.jq}/bin/jq" '.[0]|.generation' <<< "$metadata")"
          version="$("${pkgs.jq}/bin/jq" '.[0]|.nixosVersion' <<< "$metadata")"
          kernel="$("${pkgs.jq}/bin/jq" '.[0]|.kernelVersion' <<< "$metadata")"
          sudo -u "$owner" "${pkgs.git}/bin/git" -C "$etcNixos" commit -a -m "Host: $hostName, Generation: $gen, Version: $version, Kernel: $kernel" -m "$nameStatus"
        fi
      fi
    '';
  };
}
