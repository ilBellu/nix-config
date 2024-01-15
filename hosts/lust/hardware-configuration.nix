{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ../common/optional/systemd-boot.nix
  ];

  # Custom module that wraps all the tweaks to make nvidia work on my system
  nvidia-tweaks = {
    enable = true;
    cpu = "intel";
  };

  boot = {
    # Access usbs formatted by windows
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["kvm-intel"];
    };
  };

  # Enables redistributable firmware to allow updating microcode
  hardware = {
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f51495cf-6ba6-4f41-9ae6-6431d692919f";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/819D-C6C6";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/5abc898a-bc90-4ee2-a0e5-6f4ec8012526";}
  ];

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkForce "performance";
  # Update microcode if enableRedistributableFirmware is enabled
  hardware.cpu.intel.updateMicrocode = lib.mkForce config.hardware.enableRedistributableFirmware;
}
