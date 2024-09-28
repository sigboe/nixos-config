{
  description = "Ziggurat's Nix-Config";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # also see 'unstable-packages' overlay at 'overlays/default.nix"

    hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################### Utilities ####################

    # Access flake-based devShells with nix-shell seamlessly
    flake-compat.url = "github:edolstra/flake-compat";

    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vim4LMFQR!
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # optional dependency for Comma
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # style system and user packages atuomatically
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , disko
    , nixpkgs
    , home-manager
    , stylix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        #"aarch64-darwin"
      ];
      inherit (nixpkgs) lib;
      configVars = import ./vars { inherit inputs lib; };
      configLib = import ./lib { inherit lib; };
      specialArgs = {
        inherit
          inputs
          outputs
          configVars
          configLib
          nixpkgs
          self
          ;
      };
    in
    {
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      ## Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      #################### NixOS Configurations ####################

      nixosConfigurations = {
        # Desktop
        zig-pc-01 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            ./hosts/zig-pc-01
          ];
        };
        # Laptop
        zig-pc-02 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            ./hosts/zig-pc-02
          ];
        };
        # test
        vm = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            ./hosts/vm
          ];
        };
      };
    };
}