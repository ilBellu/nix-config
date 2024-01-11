{
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false; # Ensure pulseaudio isn't enabled
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
