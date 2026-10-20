{
  config,
  pkgs,
  lib,
  userName,
  userDescription,
  ...
}:

{
  # ==========================================================================
  # USER
  #
  # Name and description come from flake.nix so identity data is not duplicated
  # across multiple modules.
  # ==========================================================================

  users.users.${userName} = {
    isNormalUser = true;

    description = userDescription;
    home = "/home/${userName}";

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "vboxusers"
    ];
  };

  security.sudo.wheelNeedsPassword = true;
}
