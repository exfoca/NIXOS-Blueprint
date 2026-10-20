{ pkgs, ... }:

{
  # ==========================================================================
  # HARDWARE SHARED BY CURRENT HOSTS
  #
  # This layer contains only capabilities that are truly shared and independent of
  # the GPU vendor. CPU, PRIME, bus IDs, device-specific firmware/hardware, and
  # NVIDIA drivers remain per-host capabilities/selections. See
  # modules/system/nvidia.nix for the NVIDIA opt-in.
  # ==========================================================================

  boot.kernelPackages = pkgs.linuxPackages;

  hardware.enableRedistributableFirmware = true;

  # CPU microcode remains declared by each host's generated
  # hardware-configuration.nix.

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ==========================================================================
  # AUDIO
  # ==========================================================================

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
