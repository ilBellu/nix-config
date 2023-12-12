{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    enableMan = false; # Else it won't build
    # deafultEditor = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        key = "<Space>";
        action = "<Nop>";
        mode = ["n" "v"];
        options = {
          silent = true;
        };
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [friendly-snippets];

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

    extraConfigLuaPre =
      /*
      lua
      */
      ''
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
      '';
    plugins = {
      lsp = {
        enable = true;
        capabilities =
          /*
          lua
          */
          ''
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
          '';
        servers.nil_ls.enable = true;
        servers.clangd.enable = true;

        onAttach =
          /*
          lua
          */
          ''
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()

            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_bufkcreate_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
          '';
      };

      telescope.enable = true;

      luasnip.enable = true;

      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        sources = [
          {name = "nvim_lsp";}
          {name = "buffer";}
          {name = "cmdline";}
          {name = "path";}
          {name = "luasnip";} #For luasnip users.
        ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<Tab>" = {
            action =
              /*
              lua
              */
              ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require('luasnip').expand_or_jumpable() then
                    require('luasnip').expand_or_jump()
                  elseif has_words_before() then
                    cmp.complete()
                  else
                    fallback()
                  end
                end
              '';
            modes = [
              "i"
              "s"
            ];
          };
          "<S-Tab>" = {
            action =
              /*
              lua
              */
              ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end
              '';
            modes = ["i" "s"];
          };
        };
      };

      which-key.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<c-space>";
            nodeIncremental = "<c-space>";
            nodeDecremental = "<M-space>";
            scopeIncremental = "<c-s>";
          };
        };
      };
      lualine.enable = true;
      nix.enable = true;

      fidget.enable = true;
      clangd-extensions = {
        enable = true;
      };
    };
    extraConfigLuaPost =
      /*
      lua
      */
      ''

        -- lsp-config
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = true,
                severity_sort = false,
              })


            -- nvim-cmp


            local cmp = require("cmp")

            cmp.setup({
              window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
              sorting = {
                comparators = {
                  require("clangd_extensions.cmp_scores"),
                },
              },
            })


          require('telescope').setup {
            defaults = {
              mappings = {
                i = {
                  ['<C-u>'] = false,
                  ['<C-d>'] = false,
                },
              },
            },
          }

          -- Enable telescope fzf native, if installed
          -- pcall(require('telescope').load_extension, 'fzf')

          -- See `:help telescope.builtin`
          vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
          vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
          vim.keymap.set('n', '<leader>/', function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
             winblend = 10,
              previewer = false,
            })
          end, { desc = '[/] Fuzzily search in current buffer' })

          vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
          vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
          vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
          vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
          vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
          vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
          vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
      '';
  };
}
