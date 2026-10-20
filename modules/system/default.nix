{ ... }:

{
  # Only modules universal to the example hosts belong here. Specific capabilities,
  # such as nvidia.nix, are selected explicitly by each host.
  imports = [
    ./base.nix
    ./flatpak.nix
    ./gaming.nix
    ./hardware.nix
    ./network.nix
    ./packages.nix
    ./security.nix
    ./ssh.nix
    ./users.nix
    ./virtualization.nix
  ];
}
