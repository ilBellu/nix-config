{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users = {
    mutableUsers = true; # Eventually set to false
    motd = "Veni, Vidi, Vici";
    users.xenorock = {
      isNormalUser = true;
      shell = pkgs.fish;
      hashedPasswordFile = "/password";
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
          "networkmanager"
        ]
        ++ ifTheyExist [
          "minecraft"
          "network"
          "wireshark"
          "i2c"
          "mysql"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "deluge"
        ];
    };
  };
  # home-manager.users.misterio = import ../../../../home/misterio/${config.networking.hostName}.nix;

  services.geoclue2.enable = true;
  security.pam.services = {swaylock = {};};
}
