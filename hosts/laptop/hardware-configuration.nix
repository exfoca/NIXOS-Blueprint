# SANITIZED EXAMPLE
#
# Real filesystem UUIDs/LUKS identifiers were intentionally removed. Generate
# this file again on the target notebook before using the configuration.
#
# WARNING: the NIXOS_ROOT/NIXOS_BOOT/NIXOS_SWAP labels below are placeholders.
# If `lsblk -f` does not show these labels, DO NOT try to activate this configuration:
# regenerate this file on the target laptop with `nixos-generate-config`.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXOS_BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Optional example. Remove it if the machine does not use swap.
  swapDevices = [
    { device = "/dev/disk/by-label/NIXOS_SWAP"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
