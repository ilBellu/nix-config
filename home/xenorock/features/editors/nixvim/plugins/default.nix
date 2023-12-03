{
  gitsigns.enable = true;
  lsp = import ./lspconfig.nix;
  lspkind.enable = true;
  lspsaga.enable = true;
  lualine = import ./lualine.nix;
  luasnip.enable = true;
  luasnip.extraConfig = {update_events = "TextChanged,TextChangedI";};
  nvim-cmp = import ./cmp.nix;
  telescope.enable = true;
  treesitter.enable = true;
  treesitter.indent = true;
  treesitter.incrementalSelection.enable = true;
  treesitter-context.enable = true;
}
