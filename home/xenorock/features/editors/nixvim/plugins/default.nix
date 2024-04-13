{
  # LSP
  lsp = import ./lsp.nix;
  lsp-format.enable = true;
  # lsp-line.enable = true; # TODO: Try if you like it

  nix.enable = true; # Support for submodules ('') in nix files and other nix features

  fidget.enable = true; # Lsp status info
  clangd-extensions = {
    # TODO: Add as comparator to nvim-cmp
    enable = true;
  };

  # Snippets
  luasnip.enable = true; # Snippet engine

  cmp-nvim-lsp.enable = true; # nvim-cmp dependency
  cmp-buffer.enable = true; # nvim-cmp dependency
  cmp-cmdline.enable = true; # nvim-cmp dependency
  cmp-path.enable = true; # nvim-cmp dependency
  cmp_luasnip.enable = true; # nvim-cmp dependency for luasnip

  cmp = import ./nvim-cmp.nix;

  # Telescope
  telescope = import ./telescope.nix;

  # Utilities
  undotree.enable = true;

  # Git
  fugitive.enable = true; # Git integration. See 'rhubarb' for github integration
  gitsigns.enable = true; # Git signs for commits and diffs

  # Visual Highlights
  which-key.enable = true;

  treesitter = import ./treesitter.nix; # Better syntax highlighting
  treesitter-context.enable = true; # Keeps the context on top of the screen when scrolling

  lualine.enable = true; # Customizable status line

  trouble.enable = true; # Pretty bar for diagnostics, code actions etc. etc. TODO: integrate with 'telescope'
}
