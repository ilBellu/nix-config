{pkgs, ...}: {
  imports = [
    ../../../terminal_emulators/kitty.nix
    ./wofi.nix
    ./waybar.nix
    ./swaylock.nix
    ./swayidle.nix
    ./mako.nix
    ./zathura.nix
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    showmethekey
    grim
    gtk3
    imv
    mimeo
    pulseaudio
    slurp
    waypipe
    wf-recorder
    wl-clipboard
    wl-mirror
    # wl-mirror-pick
    ydotool
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    LIBVA_DRIVER_NAME = "nvidia"; # Nvidia try
    XDG_SESSION_TYPE = "wayland"; # Nvidia try
    GBM_BACKEND = "nvidia-drm"; # Nvidia try
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # Nvidia try
    WLR_NO_HARDWARE_CURSORS = "1"; # Nvidia try
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];
}
