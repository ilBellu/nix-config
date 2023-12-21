{
  enable = true;
  extensions.fzy-native.enable = true;
  keymaps = {
    "<leader>?" = {
      action = "oldfiles";
      desc = "[?] Find recently opened files";
    };
    "<leader><space>" = {
      action = "oldfiles";
      desc = "[ ] Find existing buffers";
    };
    "<leader>/" = {
      action = "current_buffer_fuzzy_find";
      desc = "[/] Fuzzily search in current buffer";
    };
    "<leader>gf" = {
      action = "git_files";
      desc = "Search [G]it [F]iles";
    };
    "<leader>sf" = {
      action = "find_files";
      desc = "[S]earch [F]iles";
    };
    "<leader>sh" = {
      action = "oldfiles";
      desc = "[S]earch [H]elp";
    };
    "<leader>sw" = {
      action = "oldfiles";
      desc = "[S]earch current [W]ord";
    };
    "<leader>sg" = {
      action = "oldfiles";
      desc = "[S]earch by [G]rep";
    };
    "<leader>sd" = {
      action = "oldfiles";
      desc = "[S]earch [D]iagnostics";
    };
    "<leader>sr" = {
      action = "oldfiles";
      desc = "[S]earch [R]esume";
    };
  };
}
