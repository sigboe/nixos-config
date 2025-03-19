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
      specialArgs = {
        inherit
          inputs
          outputs
          nixpkgs
          self
          ;
      };
      defaultModules = [
        home-manager.nixosModules.home-manager
        { home-manager.extraSpecialArgs = specialArgs; }
        ./modules
        stylix.nixosModules.stylix
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence
        sops-nix.nixosModules.sops
        lanzaboote.nixosModules.lanzaboote
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        nixos-cosmic.nixosModules.default
        {
          nixpkgs.overlays = [
            outputs.overlays.unstable-packages
            outputs.overlays.additions
          ];
        }
      ];
    in
    {
      ## Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      #################### NixOS Configurations ####################

      nixosConfigurations = {
        # Desktop
        lalahon = lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/lalahon ] ++ defaultModules;
        };
        # Laptop
        tala = lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/tala ] ++ defaultModules;
        };
        # Laptop
        amihan = lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/amihan ] ++ defaultModules;
        };
        # test
        vm = lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./hosts/vm ] ++ defaultModules;
        };
      };
    };
}
