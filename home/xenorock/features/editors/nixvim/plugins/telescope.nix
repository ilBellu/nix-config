{
  enable = true;
  extensions.fzy-native.enable = true;
  keymaps = {
    "<leader>?" = {
      action = "oldfiles";
      options = {
        desc = "[?] Find recently opened files";
      };
    };
    "<leader><space>" = {
      action = "oldfiles";
      options = {
        desc = "[ ] Find existing buffers";
      };
    };
    "<leader>/" = {
      action = "current_buffer_fuzzy_find";
      options = {
        desc = "[/] Fuzzily search in current buffer";
      };
    };
    "<leader>gf" = {
      action = "git_files";
      options = {
        desc = "Search [G]it [F]iles";
      };
    };
    "<leader>sf" = {
      action = "find_files";
      options = {
        desc = "[S]earch [F]iles";
      };
    };
    "<leader>sh" = {
      action = "oldfiles";
      options = {
        desc = "[S]earch [H]elp";
      };
    };
    "<leader>sw" = {
      action = "oldfiles";
      options = {
        desc = "[S]earch current [W]ord";
      };
    };
    "<leader>sg" = {
      action = "oldfiles";
      options = {
        desc = "[S]earch by [G]rep";
      };
    };
    "<leader>sd" = {
      action = "oldfiles";
      options = {
        desc = "[S]earch [D]iagnostics";
      };
    };
    "<leader>sr" = {
      action = "oldfiles";
      options = {
        desc = "[S]earch [R]esume";
      };
    };
  };
}
