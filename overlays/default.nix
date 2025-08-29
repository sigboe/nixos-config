# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  workaround-437058 = final: prev: {
    # . . . you can have other overlays in here as well.
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (python-final: python-prev: {
        # Workaround for github issue #437058
        # https://github.com/NixOS/nixpkgs/issues/437058
        i3ipc = python-prev.i3ipc.overridePythonAttrs (oldAttrs: {
          doCheck = false;
          checkPhase = ''
            echo "Skipping pytest in Nix build"
          '';
          installCheckPhase = ''
            echo "Skipping install checks in Nix build"
          '';
        });
      })
    ];
  };

}
