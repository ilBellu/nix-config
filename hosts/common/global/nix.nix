{
  inputs,
  lib,
  ...
}: {
  nix = {
    settings = {
      trusted-users = ["root" "@wheel"];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = lib.mkDefault ["nix-command" "flakes"];
      warn-dirty = lib.mkForce true;
      system-features = ["kvm" "big-parallel"];
      # flake-registry = ""; # Disable global flake registry
    };

    # Nix garbage collector
    gc = lib.mkDefault {
      automatic = true;
      dates = "weekly";
      # Keep tha generations of the last 7 days
      options = "--delete-older-than 7d";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    # registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
  };
}
