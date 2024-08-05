{
  enable = true;
  folding = true; # Treesitter based folding
  nixvimInjections = true; # Enables color highlighting in submodules along with nvim-nix
  # Select treesitter tokens incrementally
  settings = {
    indent.enable = true; # Treesitter based indenting
    incrementalSelection = {
      enable = true;
      keymaps = {
        init_selection = "<c-space>";
        node_incremental = "<c-space>";
        node_decremental = "<s-space>";
        scope_incremental = "<c-s>";
      };
    };
  };
}
