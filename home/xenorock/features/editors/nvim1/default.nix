{
  config,
  pkgs,
  lib,
  ...
}: let
  color = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
in {
  imports = [
    ./keymaps.nix
    ./plugins.nix
  ];
  home.sessionVariables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig =
      /*
      vimrc
      */
      ''
        source ${color}
      '';

    extraLuaConfig =
      lib.mkOrder 500
      /*
      lua
      */
      ''
        -- Set <space> as the leader key
        -- See `:help mapleader`
        --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ' '

        -- [[ Setting options ]]
        -- See `:help vim.o`
        -- NOTE: You can change these options as you wish!

        -- Set highlight on search
        vim.o.hlsearch = false

        -- Make line numbers default
        vim.wo.number = true

        -- Enable mouse mode
        vim.o.mouse = 'a'

        -- Sync clipboard between OS and Neovim.
        --  Remove this option if you want your OS clipboard to remain independent.
        --  See `:help 'clipboard'`
        vim.o.clipboard = 'unnamedplus'

        -- Enable break indent
        vim.o.breakindent = true

        -- Save undo history
        vim.o.undofile = true

        -- Case-insensitive searching UNLESS \C or capital in search
        vim.o.ignorecase = true
        vim.o.smartcase = true

        -- Keep signcolumn on by default
        vim.wo.signcolumn = 'yes'

        -- Decrease update time
        vim.o.updatetime = 250
        vim.o.timeoutlen = 300

        -- Set completeopt to have a better completion experience
        vim.o.completeopt = 'menuone,noselect'

        -- NOTE: You should make sure your terminal supports this
        vim.o.termguicolors = true
      '';
  };

  xdg.configFile."nvim/init.lua".onChange = ''
    XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
    for server in $XDG_RUNTIME_DIR/nvim.*; do
      nvim --server $server --remote-send ':source $MYVIMRC<CR>' &
    done
  '';

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = ["Utility" "TextEditor"];
    };
  };
}
