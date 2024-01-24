[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
![license](https://img.shields.io/github/license/ilBellu/nix-config)

# My NixOs configurations

These are my NixOs and home-manager config files.
Note that it's done using [Nix flakes](https://nixos.wiki/wiki/Flakes).

## Structure

- `flake.nix`: Entrypoint for hosts and home configurations.
- `shell.nix`: WIP.
- `hosts`: NixOS Configurations, accessible via `nixos-rebuild --flake`.
    - `common/global`: Configurations that shall be applied to all machines (even tho I only have 1 for now :-) ).
    > Entrypoint for nixos custom modules.
    - `common/optional`: Opt-in configurations.
    - `common/user`: Configurations for the various users of a system, they can be imported individually by the hosts.
- `home`: Every home-manager configuration resides here on a per-user basis.
    - `features`: Every feature which can be enabled organized in a directory structure (Structure and Documentation is still WIP).
    - `global`: Global per-user config. Ex: colorscheme, wallpaper, and hm configuration.
    > Entrypoint for home-manager custom modules.
    - `HOSTNAME.nix`: Defines the home-manager config for user@HOSTNAME.
- `modules`: Modules that are included in the config to group options where it makes sense and more easly manage some stuff which home-manager doesn't have yet.
    - `nixos`: Modules that are used in the hosts directory at the system level.
    - `home-manager`: Modules that are used by home-manager at the user level.
- `overlays`: Custom patches and modifications to derivations. Currently just [Misterio77](https://github.com/Misterio77)'s overlays.
- `pkgs`: Custom pkgs. Also exclusively imported by [Misterio77](https://github.com/Misterio77)'s flake for now.
- `templates`: Project templates accessible via `nix flake init`.

Proper Documentation, Structure graph, Entrypoints, Bootstrapping, and secret management are on their way. Meanwhile I'm including comments in every file both for my future self and anyone who decides to fork this repo.

I am particularly proud of my [NeoVim config](https://github.com/ilBellu/nix-config/tree/main/home/xenorock/features/editors/nixvim).
It is not actually impressive in terms of being an IDE as I am still working on it and will add/refine keybinds and plugins when I need them.
But it does feature LSPs, treesitter, git integration and a snippet engine.
What makes it unique for me is that it's all managed through hm using nix modules and the occasional lua submodule.
It does not include a single standalone or symlinked *.lua file.

## Credits

Special thanks to github user [Misterio77](https://github.com/Misterio77) who heavely inspired both my switch to NixOs and this configuration.
Other projects and users which heavily inspired and helped be during my journey with nix/NixOs:
- [Mic92](https://github.com/Mic92)
- [Xe laso](https://github.com/Xe)
- Everyone who contributed to the project [NixVim](https://github.com/nix-community/nixvim) which helped me immensly advance my understanding of the nix language, home-manager and lua.


