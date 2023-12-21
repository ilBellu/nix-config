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
    ++ (builtins.attrValues outputs.homeManagerModules);
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "xenorock";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
  };

  systemd.user.startServices = "sd-switch";

  colorscheme = lib.mkDefault colorSchemes.onedark;
  home.file.".colorscheme".text = config.colorscheme.slug;

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
