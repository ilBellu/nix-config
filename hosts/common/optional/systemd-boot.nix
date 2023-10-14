{lib, ...}: {
  boot.loader = lib.mkDefault {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
  };
}
