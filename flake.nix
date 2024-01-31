{
  description = "My NixOs configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Misterio77 nix-config
    misterio77-nix-config = {
      url = "github:Misterio77/nix-config";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Module to configure nvim within nix via home-manager
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    misterio77-nix-config,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux"];
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
    });
    forEachSystem = func: lib.genAttrs systems (system: func pkgsFor.${system});
  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = misterio77-nix-config.homeManagerModules // import ./modules/home-manager;
    templates = import ./templates;

    overlays = import ./overlays {inherit inputs outputs;} // misterio77-nix-config.overlays;

    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;}) // misterio77-nix-config.packages;
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      "lust" = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/lust];
      };
    };

    homeConfigurations = {
      "xenorock@lust" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/xenorock/lust.nix];
        extraSpecialArgs = {
          inherit inputs outputs;
          hostName = "lust";
        };
      };
    };
  };
}
