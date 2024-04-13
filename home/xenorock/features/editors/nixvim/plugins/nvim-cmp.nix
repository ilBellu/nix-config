{
  enable = true;

  # Snippets & sorting
  settings = {
    snippet.expand = "luasnip"; # Needed for luasnip snippet engine support
    sources = [
      {name = "nvim_lsp";}
      {name = "buffer";}
      {name = "luasnip";} # For luasnip users.
      # {name = "cmdline";}
      # {name = "path";}
    ];
    sorting.comparators = ["offset" "exact" "score" "recently_used" "locality" "kind" "length" "order"];

    # Styling
    window = let
      common_border = {
        border = "rounded";
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
      };
    in {
      completion = common_border;
      documentation = common_border;
    };

    # Mappings
    mapping = {
      "<CR>" =
        /*
        lua
        */
        ''cmp.mapping.confirm({ select = true })'';
      "<C-b>" =
        /*
        lua
        */
        ''cmp.mapping.scroll_docs(-4)'';
      "<C-f>" =
        /*
        lua
        */
        ''cmp.mapping.scroll_docs(4)'';
      "<C-Space>" =
        /*
        lua
        */
        ''cmp.mapping.complete()'';
      "<C-e>" =
        /*
        lua
        */
        ''cmp.mapping.abort()'';
      # "<Tab>" = {
        # action =
          # /*
          # lua
          # */
          # ''
            # function(fallback)
              # local has_words_before = function()
                # unpack = unpack or table.unpack
                # local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                # return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
              # end
#
              # if cmp.visible() then
                # cmp.select_next_item()
              # elseif require('luasnip').expand_or_jumpable() then
                # require('luasnip').expand_or_jump()
              # elseif has_words_before() then
                # cmp.complete()
              # else
                # fallback()
              # end
            # end
          # '';
        # modes = [
          # "i"
          # "s"
        # ];
      # };
      # "<S-Tab>" = {
        # action =
          # /*
          # lua
          # */
          # ''
            # function(fallback)
              # if cmp.visible() then
                # cmp.select_prev_item()
              # elseif luasnip.jumpable(-1) then
                # luasnip.jump(-1)
              # else
                # fallback()
              # end
            # end
          # '';
        # modes = ["i" "s"];
      # };
    };
    # # extraOptions = {
    # # sorting.comparators = "require('clangd_extensions.cmp_scores')"; # TODO: make clangd_extensions a comparator
    # # };
  };
}
