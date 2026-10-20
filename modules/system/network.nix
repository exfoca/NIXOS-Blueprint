{ ... }:

{
  # ==========================================================================
  # NETWORK
  # ==========================================================================

  networking.networkmanager.enable = true;

  # Firewall enabled by default. Each service must explicitly declare when it
  # needs to open its own port.
  networking.firewall.enable = true;
}
