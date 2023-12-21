{
  enable = true;
  indent = true; # Treesitter based indenting
  folding = true; # Treesitter based folding
  nixvimInjections = true; # Enables color highlighting in submodules along with nvim-nix
  # Select treesitter tokens incrementally
  incrementalSelection = {
    enable = true;
    keymaps = {
      initSelection = "<c-space>";
      nodeIncremental = "<c-space>";
      nodeDecremental = "<s-space>";
      scopeIncremental = "<c-s>";
    };
  };
}
