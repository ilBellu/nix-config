{
  pkgs,
  config,
  ...
}: let
  color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
in {
  home.sessionVariables.EDITOR = "nvim";
  programs.nixvim = {
    enable = true;
    enableMan = false; # Else it won't build

    clipboard.register = "unnamedplus";

    globals = {
      # For now only usefull for leader key, any other option can be set using options which uses 'vim.opt' under the hood
      mapleader = " ";
      maplocalleader = " ";
    };

    options = import ./options.nix;

    keymaps = import ./keymaps.nix;

    # extraPlugins = with pkgs.vimPlugins; [friendly-snippets];
    plugins = import ./plugins;

    # Colors that change based on the OS Theme thanks to github user misterio77
    extraConfigVim =
      /*
      vimrc
      */
      ''source ${color}'';
  };
}
