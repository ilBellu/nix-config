{
  inputs,
  pkgs,
  outputs,
  lib,
  config,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) nixWallpaperFromScheme;
in {
  imports =
    [
      inputs.nix-colors.homeManagerModule
      ../features/cli
    ]
    ++ (builtins.attrValues outputs.homeManagerModules); # Entry point for custom homeManager modules

  # Needed for homeManager and flakes to work
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  # Sets up homeManager for the user
  home = {
    username = lib.mkDefault "xenorock";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
  };

  # Wether new or changed services should be started automatically if they are wanted targets
  systemd.user.startServices = "sd-switch";

  colorscheme = lib.mkDefault colorSchemes.onedark;
  home.file.".colorscheme".text = config.colorscheme.slug;

  # If no custom wallpaper is defined in the configuration the default will be created from the colorscheme
  wallpaper = let
    largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
    largestWidth = largest (x: x.width) config.monitors;
    largestHeight = largest (x: x.height) config.monitors;
  in
    lib.mkDefault (nixWallpaperFromScheme
      {
        scheme = config.colorscheme;
        width = largestWidth;
        height = largestHeight;
        logoScale = 4;
      });
}
