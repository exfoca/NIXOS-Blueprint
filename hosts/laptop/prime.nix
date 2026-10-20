{ ... }:

{
  # ==========================================================================
  # NVIDIA PRIME / OPTIMUS - HYBRID LAPTOP (EXAMPLE)
  #
  # Example Intel iGPU + NVIDIA dGPU topology.
  # On Wayland, PRIME Sync does not apply: the session uses the iGPU while the NVIDIA
  # GPU remains available for render offload on demand.
  # ==========================================================================

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # EXAMPLE: Intel iGPU - confirm with `lspci` on your machine.
    intelBusId = "PCI:0@0:2:0";

    # EXAMPLE: NVIDIA dGPU - confirm with `lspci` on your machine.
    nvidiaBusId = "PCI:1@0:0:0";
  };
}
