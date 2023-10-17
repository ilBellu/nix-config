{
  pkgs,
  config,
  lib,
  ...
}: let
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (oldAttrs: {
    postPatch = "";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "49e71322db582147ce8f4df1853d9dab08da0826";
      hash = "sha256-i7/YKin/AuUgzKvGgAzNTEGXlrejtucJacFXh8t/uFs=";
    };
  });
in {
  programs.neovim = {
    extraConfig =
      lib.mkAfter
      /*
      vim
      */
      ''
        function! SetCustomKeywords()
          syn match Todo  /TODO/
          syn match Done  /DONE/
          syn match Start /START/
          syn match End   /END/
        endfunction

        autocmd Syntax * call SetCustomKeywords()
      '';
    plugins = with pkgs.vimPlugins; [
      rust-vim
      vim-markdown
      vim-nix
      vim-toml
      pgsql-vim
      vim-jsx-typescript
      {
        plugin = vimtex;
        config = let
          method =
            if config.programs.zathura.enable
            then "zathura"
            else "general";
        in ''
          let g:vimtex_view_method = '${method}'
        '';
      }

      # Tree sitter
      {
        plugin = nvim-treesitter;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require('nvim-treesitter.configs').setup{
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
            }
          '';
      }
    ];
  };
}
