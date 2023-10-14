{pkgs, ...}: {
  imports = [
    ../../../terminal_emulators/kitty.nix
  ];

  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };
}
