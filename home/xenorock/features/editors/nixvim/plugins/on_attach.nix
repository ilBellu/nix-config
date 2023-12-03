let
  opts = "noremap = true, buffer = bufnr";
in ''
  -- Configure Omnifunc
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Keymaps
  vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { desc = 'Hover Documentation', ${opts} })
  vim.keymap.set('n', '<leader>r', '<Cmd>Lspsaga rename<CR>', { desc = '[R]ename', ${opts} })
  vim.keymap.set({ 'n', 'v' }, '<leader>fa', '<Cmd>Lspsaga code_action<CR>', { desc = '[F]ind Code [A]ctions', ${opts} })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]o to [D]efinition', ${opts} })
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { desc = '[G]o to [T]ype Definition', ${opts} })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '[G]o to [I]mplementation', ${opts} })
   -- Formatting support
   if client.supports_method 'textDocument/formatting' then
    vim.keymap.set('n', '<leader>w', function() vim.lsp.buf.format { async = true } end, { desc = 'Format Buffer', ${opts} })
  else
    vim.keymap.set('n', '<leader>w', function() print 'Formating not supported for this language' end, { desc = '[Not Supported for filetype] Format Buffer', ${opts} })
  end
''
