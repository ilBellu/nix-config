{lib, ...}: {
  security.rtkit.enable = lib.mkDefault true;
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa = lib.mkDefault {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = lib.mkDefault true;
  };
}
