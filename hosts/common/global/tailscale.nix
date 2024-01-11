{
  services.tailscale.enable = true;

  networking.firewall = {
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
