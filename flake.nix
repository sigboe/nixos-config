{
  description = "Ziggurat's Nix-Config";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
      follows = "nixos-cosmic/nixpkgs-stable";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # also see 'unstable-packages' overlay at 'overlays/default.nix"
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    nix-secrets = {
      url = "git+ssh://git@gitlab.com/sigboe/nix-secrets.git?ref=main&shallow=1";
    };

    # vim4LMFQR!
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # optional dependency for Comma
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # style system and user packages atuomatically
    stylix = {
      url = "github:danth/stylix/release-24.11";
    };

    # Cosmic Desktop
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

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
    , nixos-cosmic
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
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
            nixos-cosmic.nixosModules.default
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
              nixpkgs.overlays = [
                outputs.overlays.unstable-packages
                outputs.overlays.additions
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
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      #################### NixOS Configurations ####################

      nixosConfigurations = mkHostConfigs (readHosts ./hosts);
    };
}
