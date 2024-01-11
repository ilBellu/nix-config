{
  programs.fish = {
    # Enable fish. NOTE: fish is also enabled at the home-manager level but this ensures it is installed even in machines not managed by home-manager
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
}
