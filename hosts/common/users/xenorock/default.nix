{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users = {
    mutableUsers = false;
    motd = "Veni, Vidi, Vici";
    users.xenorock = {
      isNormalUser = true;
      shell = pkgs.fish;
      hashedPasswordFile = "/password"; # TODO: Eventually move to nix-sops
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
        ]
        ++ ifTheyExist [
          "network"
          "wireshark"
          "i2c"
          "mysql"
          "docker"
          "podman"
          "git"
          "libvirtd"
        ];
    };
  };

  security.pam.services = {swaylock = {};};
}
