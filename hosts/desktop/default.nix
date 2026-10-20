{ userName, ... }:

{
  imports = [
    # Opt-in capability: remove on hosts without an NVIDIA GPU.
    ../../modules/system/nvidia.nix
    ./hardware-configuration.nix
    ./wifi.nix
    ./plasma.nix
  ];

  # Ryzen 5 5600X without an iGPU: PRIME does not apply to this example host.

  # Allow the x86_64 desktop to run aarch64-linux binaries and derivations through
  # binfmt/QEMU. Useful for building NixOS images for ARM SBCs.
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  # Example-specific tuning for the Ryzen 5 5600X.
  nix.settings.cores = 0;
  nix.settings.max-jobs = 6;

  # Example per-host SSH authorization. Real keys are not published to avoid linking
  # people/devices to the repository. Replace AAAA... with your public key if you
  # want to enable login on this host.
  # users.users.${userName}.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAA... workstation"
  # ];
}
