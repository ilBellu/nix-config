{
  enable = true;
  capabilities =
    # Does this automatically however it tends to override itself
    # TODO: Look wether installed plugins expose capabilities which are not advertised
    /*
    lua
    */
    ''
      -- Pulled from https://github.com/oxalica/nil/blob/main/dev/nvim-lsp.nix
      -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
      -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/42#issuecomment-1283825572
      local caps = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        -- File watching is disabled by default for neovim.
        -- See: https://github.com/neovim/neovim/pull/22405
        { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
      );
    '';

  servers.bashls.enable = true; # Bash language server (No additional capabilities)
  servers.clangd =
    # C & Cpp language server (No additional capabilities)
    {
      enable = true;
      onAttach.function =
        /*
        lua
        */
        ''
          require("clangd_extensions.inlay_hints").setup_autocmd()
          require("clangd_extensions.inlay_hints").set_inlay_hints()
        '';
    };
  servers.nil_ls.enable = true; # Nix language server (Requires the code above to expose additional capabilities)

  # TODO: Check if in the future the attribute set will support specifying a description for the keymap
  # TODO: Check if in the future the attribute set will support specifying a custom command hence removing the need for the code in onAttach
  keymaps = {
    diagnostic = {
      "<leader>j" = "goto_next";
      "<leader>k" = "goto_prev";
    };

    lspBuf = {
      "<leader>rn" = "rename"; # Rename symbol
      "<leader>ca" = "code_action";
      "K" = "hover"; # Hover Documentation
      "<C-k>" = "signature_help"; # Signature Documentation
      "gD" = "declaration"; # Goto declaration
      "<leader>wa" = "add_workspace_folder";
      "<leader>wr" = "remove_workspace_folder";
      "<leader>wl" = "list_workspace_folders";
      "<leader>ft" = "format"; # Format current buffer
    };
  };

  onAttach =
    # TODO: reformat keybinds
    /*
    lua
    */
    ''
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      -- Telescope builtins require to be declared in lua because of lack of support
      -- https://github.com/nix-community/nixvim/blob/6d72e00455634cd4380f7d52009bbf3b25969189/plugins/lsp/default.nix#L115C17-L115C20
      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    '';

  postConfig =
    /*
    lua
    */
    ''
      vim.diagnostic.config({
          virtual_text = true,
          signs = true,
          underline = true,
          update_in_insert = true,
          severity_sort = true,
        })

    '';
}
