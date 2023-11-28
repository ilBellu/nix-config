{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-fugitive # Git integration
    vim-rhubarb # Github integration

    vim-sleuth # Detect tabstop and shiftwidth automatically

    lsp-zero-nvim
    {
      plugin = nvim-lspconfig; # LSP configuration & plugins
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local lspconfig = require('lspconfig')
          lspconfig.nil_ls.setup{}
        '';
    }
    ## Dependencies
    # mason-nvim # Automatically install LSPs to stdpath for neovim TODO: make lsps declarative
    # mason-lspconfig-nvim # Compatibiliy plugin
    fidget-nvim # Status updates for LSP
    neodev-nvim # Lua LSP configuration
    ## End

    # Autocompletion
    nvim-cmp
    ## Dependencies
    # Snippet Engine & its associated nvim-cmp source
    luasnip
    cmp_luasnip

    cmp-nvim-lsp # Adds LSP completion capabilities

    friendly-snippets # Adds a number of user-friendly snippets
    ## End

    which-key-nvim # Useful plugin to show you pending keybinds

    {
      plugin = gitsigns-nvim; # Adds git related signs to the gutter, as well as utilities for managing changes
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require('gitsigns').setup {
            signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
          on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

            -- don't override the built-in and fugitive keymaps
            local gs = package.loaded.gitsigns
            vim.keymap.set({ 'n', 'v' }, ']c', function()
              if vim.wo.diff then
                return ']c'
              end
              vim.schedule(function()
                gs.next_hunk()
              end)
              return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
            vim.keymap.set({ 'n', 'v' }, '[c', function()
              if vim.wo.diff then
                return '[c'
              end
              vim.schedule(function()
                gs.prev_hunk()
              end)
              return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
          end,
          }
        '';
    }

    {
      plugin = lualine-nvim; # Set lualine as statusline
      type = "lua";
      # TODO: change config to better one
      config =
        /*
        lua
        */
        ''
                  require('lualine').setup {options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
              statusline = {},
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
              statusline = 1000,
              tabline = 1000,
              winbar = 1000,
            }
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {}
                  }
        '';
    }

    indent-blankline-nvim # Add indentation guides even on blank lines

    comment-nvim # "gc" to comment visual regions/lines

    # Fuzzy finder
    telescope-nvim
    telescope-fzf-native-nvim # Fuzzy finder algorithm
    plenary-nvim

    # Highlight, edit, and navigate code
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
  ];
}
