{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./bat.nix # Better cat
    ./direnv.nix # Auto source flake when entering directory: loads environment variables, shells and secrets
    ./fish.nix # Better shell
    # ./gh.nix
    ./git.nix
    # ./gpg.nix
    # ./jujutsu.nix
    # ./lyrics.nix
    # ./nix-index.nix
    ./pfetch.nix
    ./ranger.nix # TUI file explorer
    ./screen.nix
    # ./shellcolor.nix
    # ./ssh.nix
    ./starship.nix # Terminal prompt
    # ./xpo.nix
    ../editors/nixvim # Nvim
  ];
  home.packages = with pkgs; [
    bc # Calculator
    bottom # System viewer
    # ncdu # TUI disk usage
    eza # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator

    # nil # Nix LSP
    # nixfmt # Nix formatter
    # nix-inspect # See which pkgs are in your PATH

    ltex-ls # Spell checking LSP

    # tly # Tally counter

    busybox # General utilities

    figlet # Fun
    lolcat # Fun
    # inputs.nh.default # nixos-rebuild and home-manager CLI wrapper
  ];
}
