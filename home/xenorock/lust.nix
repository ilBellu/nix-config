{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/browsers/firefox.nix
    ./features/comunication/discord.nix
    #    inputs.hyprland.homeManagerModules.default
  ];

  colorscheme = inputs.nix-colors.colorschemes.tokyo-night-storm;
  wallpaper = outputs.wallpapers.watercolor-beach;

  nixpkgs.config.allowUnfree = true;

  monitors = [
    {
      name = "DP-1";
      width = 3840;
      height = 2160;
      refreshRate = 59.99700;
      scale = 1.25;
      x = 0;
      y = 0;
      workspace = "1";
      enabled = true;
    }
    {
      name = "HDMI-A-1";
      primary = true;
      width = 1920;
      height = 1080;
      refreshRate = 50.0;
      scale = 1.0;
      x = 0;
      y = 0;
      workspace = "1";
      enabled = false;
    }
  ];
}
