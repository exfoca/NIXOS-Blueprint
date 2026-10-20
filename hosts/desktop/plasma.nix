{
  userName,
  keyboardLayout,
  ...
}:

{
  # ==========================================================================
  # DESKTOP GRAPHICAL ENVIRONMENT - KDE Plasma 6 + Wayland
  #
  # This example assumes an NVIDIA GPU drives the display directly.
  # ==========================================================================

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = keyboardLayout;
    variant = "";
  };

  environment.etc."xdg/kxkbrc".text = ''
    [Layout]
    LayoutList=${keyboardLayout}
    Use=true
  '';

  # Always-on workstation. Remove this block on machines where automatic
  # suspend/hibernation is desired.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowSuspendThenHibernate = false;
    AllowHybridSleep = false;
  };

  powerManagement.cpuFreqGovernor = "performance";

  # Desktop-specific preferences applied to the same user created by the shared
  # module.
  home-manager.users.${userName} = { lib, ... }: {
    programs.plasma = {
      kscreenlocker = {
        autoLock = false;
        lockOnResume = lib.mkForce false;
        lockOnStartup = false;
      };

      powerdevil.AC = {
        powerButtonAction = "nothing";
        autoSuspend.action = "nothing";
        turnOffDisplay.idleTimeout = "never";
        dimDisplay.enable = false;
        powerProfile = "performance";
      };
    };
  };
}
