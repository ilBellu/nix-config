{lib, ...}: {
  services.tailscale.enable = lib.mkDefault true;

  networking.firewall = lib.mkDefault {
    checkReversePath = "loose";
    allowedUDPPorts = [41641]; # Facilitate firewall punching
  };
}
