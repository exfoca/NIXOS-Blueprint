{ userName, ... }:

{
  imports = [
    # Opt-in capability: remove on hosts without an NVIDIA GPU.
    ../../modules/system/nvidia.nix
    ./hardware-configuration.nix
    ./plasma.nix
    ./prime.nix
  ];

  # Conservative tuning for the example laptop.
  nix.settings.cores = 0;
  nix.settings.max-jobs = 4;

  # Example SSH authorization specific to this host.
  # users.users.${userName}.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAA... laptop"
  # ];
}
