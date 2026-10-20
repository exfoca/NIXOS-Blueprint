{ config, lib, ... }:

{
  # ==========================================================================
  # NVIDIA - OPT-IN CAPABILITY
  #
  # DO NOT import this module on AMD/Intel-only hosts. It enables the NixOS NVIDIA
  # stack (including open kernel modules in this example). The example hosts select
  # this capability explicitly.
  # ==========================================================================

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };

  # Enable NVIDIA container integration only when Docker is also active.
  # `mkDefault` preserves this automatic behavior while allowing a host/project to
  # override the decision explicitly without competing for priority with this module.
  hardware.nvidia-container-toolkit.enable =
    lib.mkDefault config.virtualisation.docker.enable;
}
