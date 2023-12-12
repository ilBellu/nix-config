{ pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    enableMan = false; # Else it won't build
    # deafultEditor = true;
    globals.mapleader = " ";

    clipboard.register = "unnamedplus";

    colorschemes.onedark.enable = true;

    options = {
      number = true;
      relativenumber = true;
      cursorline = false;
      wrap = false;
      splitright = true;
      tabstop = 4;
      softtabstop = 0;
      shiftwidth = 0;
      expandtab = true;

      smarttab = true;
      autoindent = true;
      smartindent = true;

      path = ".,/usr/include,**";
      wildmenu = true;
      hlsearch = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true;
    };

    plugins = {
        lsp = {
            enable = true;
            servers.nil_ls.enable = true;
            servers.clangd.enable = true;
        };
    };

  };
}
