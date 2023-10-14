{inputs, outputs, ...}: {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/browsers/firefox.nix
    #    inputs.hyprland.homeManagerModules.default
  ];

  colorscheme = inputs.nix-colors.colorschemes.tokyo-night-storm;
  wallpaper = outputs.wallpapers.watercolor-beach;

  monitors = [
    {
      name = "DP-1";
      primary = true;
      width = 3840;
      height = 2160;
      refreshRate = 59.99700;
      scale = 1.25;
      x = 0;
      y = 0;
      workspace = "1";
    }
  ];
}
