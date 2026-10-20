{ pkgs, ... }:

{
  # ==========================================================================
  # GAMING
  #
  # Shared capability: it does not depend on a host's physical identity.
  # ==========================================================================

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
  ];
}
