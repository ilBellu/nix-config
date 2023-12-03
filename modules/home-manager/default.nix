{inputs, ...}: {
  fonts = import ./fonts.nix;
  monitors = import ./monitors.nix;
  wallpaper = import ./wallpaper.nix;
  # nixvim = inputs.nixvim.homeManagerModules;
}
