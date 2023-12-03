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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    # current_system = "x86_64-linux";
    systems = ["x86_64-linux"];
    # pkgs = nixpkgs.legacyPackages.${current_system};
    pkgsFor = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system});
    forEachSystem = func: lib.genAttrs systems (system: func pkgsFor.${system});
  in {
    # formatter.x86_64-linux = pkgs.alejandra;
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    homeManagerModules = import ./modules/home-manager {inherit inputs;};

    wallpapers = import ./home/xenorock/wallpapers;

    nixosConfigurations = {
      "lust" = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [./hosts/lust];
      };
    };

    homeConfigurations = {
      "xenorock@lust" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/xenorock/lust.nix];
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
