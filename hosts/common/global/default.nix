{inputs, ...}: {
  imports = [
    ./locale.nix
    ./pipewire.nix
    ./systemd-initrd.nix
    ./nix.nix
    ./tailscale.nix
    ./fish.nix
  ];

  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = ["/lib/qt-6/plugins"];
  };

  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}
