{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    # Prefer manually using fish
    enableFishIntegration = false;
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
