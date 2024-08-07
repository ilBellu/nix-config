{
  imports = [
    ./browsers/firefox.nix
    ./dragon.nix
    ./pavucontrol.nix
    ./font.nix
    ./deluge.nix
    ./vlc.nix
    ./keepassxc.nix
    ./gtk.nix
    ./kdeconnect.nix
    ./playerctl.nix
    ./qt.nix
    # ./sublime-music.nix
  ];

  xdg.portal.enable = true;
}
