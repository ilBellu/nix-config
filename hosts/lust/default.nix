{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global

    ../common/users/xenorock
  ];

  networking = {
    hostName = "lust"; # Define your hostname.
    # useDHCP = lib.mkForce true;
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    nameservers = ["100.100.100.100" "1.1.1.1" "8.8.8.8"];
    search = ["tail2df32.ts.net"];
  };

  nixpkgs.config.allowUnfree = true; # Nvidia try


  programs = {
    # dconf.enable = true;
    # adb.enable = true; # Not needed for now
    kdeconnect.enable = true;
  };

  fonts.enableDefaultPackages = true; # TODO: check if font module actually works and fix nerdfonts not displaying in firefox

  services.dbus.implementation = "broker"; # TODO: maybe move to global

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland xdg-desktop-portal-gtk]; # Gtk portal is added for filepicker
    # Since portal implementation changed we need to define the portals to use in order or use * for lexicographical order
    config.common.default = [ "hyprland" "wlr" "gtk" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
