{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./bat.nix # Better cat
    ./direnv.nix # Auto source flake when entering directory: loads environment variables, shells and secrets
    ./fish.nix # Better shell
    ./gh.nix # Github CLI
    ./git.nix
    # ./gpg.nix
    # ./jujutsu.nix
    ./nix-index.nix
    # ./thefuck.nix # Enables thefuck command correction
    ./pfetch.nix # Better neofetch
    ./ranger.nix # TUI file explorer
    ./screen.nix # Usefull for ssh multitasking
    ./shellcolor.nix # Utility to change running terminal colorscheme
    # ./ssh.nix
    ./zoxide.nix # Better cd
    ./starship.nix # Terminal prompt
    # ./xpo.nix
    ../editors/nixvim # Nvim
  ];
  home.packages = with pkgs; [
    comma # Nix command to run programs without installing them by preceding them with a comma
    nh # NixOs and HM wrapper
    bc # Calculator
    bottom # System viewer
    # ncdu # TUI disk usage
    eza # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator

    busybox # General utilities

    figlet # Fun
    lolcat # Fun
  ];
}
