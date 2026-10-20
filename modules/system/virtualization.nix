{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # DOCKER
  #
  # Security note: members of the `docker` group effectively have root-equivalent
  # access through the daemon. See modules/system/users.nix.
  # ==========================================================================

  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      log-driver = "json-file";

      "log-opts" = {
        "max-size" = "50m";
        "max-file" = "3";
      };
    };
  };

  # ==========================================================================
  # VIRTUALBOX
  # ==========================================================================

  virtualisation.virtualbox.host.enable = true;

  # ==========================================================================
  # APPIMAGE
  # ==========================================================================

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
