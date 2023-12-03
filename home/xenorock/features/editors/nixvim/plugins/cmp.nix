{
  enable = true;
  # Snippets
  snippet.expand = "luasnip";
  # Completion Sources
  # Menu Icons
  mappingPresets = ["insert"];
  mapping = {
    "<C-n>" = {
      modes = ["i" "s"];
      action = ''
        function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end
      '';
    };
    "<C-p>" = {
      modes = ["i" "s"];
      action = ''
        function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end
      '';
    };
    "<C-u>" = ''
      cmp.mapping(function(fallback)
        if require("luasnip").choice_active() then
          require("luasnip").next_choice()
        else
          fallback()
        end
      end)
    '';
    "<C-b>" = "cmp.mapping.scroll_docs(-4)";
    "<C-f>" = "cmp.mapping.scroll_docs(4)";
    "<C-Space>" = "cmp.mapping.complete {}";
    "<C-e>" = "cmp.mapping.close()";
    "<CR>" = "cmp.mapping.confirm { select = true }";
  };
}
