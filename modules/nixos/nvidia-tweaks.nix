{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.nvidia-tweaks;
in {
  # See: https://nixos.wiki/wiki/Nvidia
  options.nvidia-tweaks = {
    enable = mkEnableOption (lib.mdDoc "Enable nvidia drivers and tweaks to hopefully make them work (nvidia sucks). WARNING: This module enables unfree software");

    cpu = mkOption {
      type = types.enum ["intel" "amd"];
      default = "intel";
      description = ''
        Used to blacklist the kernel module for the corresponding cpu,
        also sets the modeset for the i915 module to 0 if intel is chosen
        since the modesetting happens even with the module blacklisted.
        Fixes a compatibility issue with nvidia and intel/amd integrated gpu drivers.
      '';
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = mkDefault ["nvidia"]; # Used to tell the system which graphics backend to use even on wayland

    hardware = {
      graphics.extraPackages = with pkgs; mkDefault [vaapiVdpau]; # Nvidia opengl package for hardware acceleration

      nvidia = {
        # Read from config the value of kernelPackages so the right package for the kernel in use will be installed
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = mkDefault true; # Required
        nvidiaSettings = mkDefault true; # Enable Nvidia Settings menu
      };
    };

    boot = {
      # There may be a conflict between integrated and nvidia drivers on some systems
      blacklistedKernelModules =
        if (cfg.cpu == "intel")
        then mkDefault ["i915"]
        else mkDefault ["amdgpu"];
      kernelParams =
        if (cfg.cpu == "intel")
        # The max_cstate option fixes an issue with slow video playback
        then mkDefault ["i915.modeset=0 intel_idle.max_cstate=0"]
        else mkDefault ["radeon.modeset=0"];

      # Fixes if Booting to Text Mode doesn't work. See: https://nixos.wiki/wiki/Nvidia#Booting_to_Text_Mode
      extraModulePackages = mkDefault [config.boot.kernelPackages.nvidia_x11];
      initrd.kernelModules = mkDefault ["nvidia"];
    };
  };
}
