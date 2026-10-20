{ ... }:

{
  # ============================================================================
  # KDE PLASMA 6 - SHARED USER PREFERENCES
  #
  # Keep only stable invariants shared by the desktop and laptop. Monitor-, panel-,
  # and hardware-specific state stays outside this layer.
  # ============================================================================

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      iconTheme = "breeze-dark";
    };

    input.keyboard.numlockOnStartup = "on";

    kscreenlocker = {
      lockOnResume = true;
      timeout = 10;
    };
  };
}
