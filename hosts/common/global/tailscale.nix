{lib, ...}: {
  services.tailscale.enable = lib.mkDefault true;

  networking.firewall = lib.mkDefault {
    checkReversePath = "loose";
    allowedUDPPorts = [41641]; # Facilitate firewall punching
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
