{ pkgs, ... }:{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    aliases = {
      p = "pull --ff-only";
      ff = "merge --ff-only";
      graph = "log --decorate --oneline --graph";
    };
    userName = "ilBellu";
    userEmail = "92112592+ilBellu@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      # commit.gpgSign = true; # TODO: create a gpg signing key
    };
    lfs.enable = true;
    ignores = [ "result" ];
  };
}
