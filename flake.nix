{
  description = "Ziggurat's Nix-Config";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################### Utilities ####################

    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TPM chip
    lanzaboote.url = "github:nix-community/lanzaboote";

    # Impermanence (nuke root on every boot)
    impermanence.url = "github:nix-community/impermanence";

    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Authenticate via ssh and use shallow clone
    nix-secrets.url = "git+ssh://git@gitlab.com/sigboe/nix-secrets.git?ref=main&shallow=1";

    # vim4LMFQR!
    nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs"; #this is unsupported
    };

    # optional dependency for Comma
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , disko
    , nixpkgs
    , home-manager
    , stylix
    , impermanence
    , sops-nix
    , lanzaboote
    , jovian
    , nixos-wsl
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        #"aarch64-darwin"
      ];
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
      mkHost = host: {
        ${host} = lib.nixosSystem rec {
          specialArgs = { inherit inputs outputs self host; };
          modules = [
            ./hosts/${lib.removeSuffix "-bootstrap" host}
            ./modules
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
            jovian.nixosModules.jovian
            nixos-wsl.nixosModules.default
            {
              home-manager.backupFileExtension = "backup";
              nixpkgs.overlays = [
                outputs.overlays.unstable-packages
                outputs.overlays.stable-packages
                outputs.overlays.additions
                outputs.overlays.workaround-437058
              ];
            }
          ];
        };
      };
      mkHostConfigs = hosts: lib.foldl (acc: set: acc // set) { } (lib.map mkHost (hosts ++ addSuffix "-bootstrap" hosts));
      readHosts = folder: builtins.attrNames (lib.filterAttrs (name: type: name != "common") (lib.filterAttrs (name: type: type == "directory") (builtins.readDir "${folder}")));
      addSuffix = suffix: arr: (map (x: "${x}${suffix}") arr);
    in
    {
      ## Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${nixpkgs.stdenv.hostPlatform.system});

      #################### NixOS Configurations ####################

      nixosConfigurations = mkHostConfigs (readHosts ./hosts);
    };
}
