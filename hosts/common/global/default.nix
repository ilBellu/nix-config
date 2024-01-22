{outputs, ...}: {
  imports =
    [
      ./locale.nix
      ./pipewire.nix
      ./systemd-initrd.nix
      ./nix.nix
      ./tailscale.nix
      ./fish.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules); # Entry point for custom nixos modules

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays; # Entry point for system overlays
  };

  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = ["/lib/qt-6/plugins"];
  };

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
