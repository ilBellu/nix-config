{pkgs, ...}: {
  # TODO: Check if this can be moved to home-manager config
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk]; # Gtk portal is added for filepicker
    # Since portal implementation changed we need to define the portals to use in order or use * for lexicographical order
    config.common.default = [ "hyprland" "wlr" "gtk" ];
  };
}
