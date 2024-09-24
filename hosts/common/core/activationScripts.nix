{ pkgs, self, ... }: {
  system.activationScripts = {
    gitcommit.text = ''
      etcNixos="$(readlink -f /etc/nixos)"
      internalOutPath="${self.sourceInfo.outPath}"
      etcNixosOutPath="$(${pkgs.nix}/bin/nix flake metadata --json "$etcNixos" | ${pkgs.jq}/bin/jq -r .path)"

      if [ $internalOutPath == $etcNixosOutPath ] && \
      ${pkgs.git}/bin/git -C $etcNixos rev-parse --is-inside-work-tree
      then
        metadata="$(${pkgs.nixos-rebuild}/bin/nixos-rebuild list-generations --json)"
        gen="$(${pkgs.jq} '.[0]|.generation' <<< "$metadata")"
        version="$(${pkgs.jq} '.[0]|.nixosVersion' <<< "$metadata")"
        kernel="$(${pkgs.jq} '.[0]|.kernelVersion' <<< "$metadata")"
        ${pkgs.git}/bin/git commit -am "Host: $HOST, Generation: $gen, Version: $version, Kernel: $kernel"
      fi
    '';
  };
}
