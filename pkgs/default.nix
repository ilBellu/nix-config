{pkgs ? import <nixpkgs> {}}: {
  shellcolord = pkgs.callPackage ./shellcolord {};
  wallpapers = pkgs.callPackage ./wallpapers {};
}
