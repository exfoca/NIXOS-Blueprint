{ keyboardLayout, ... }:

{
  # ==========================================================================
  # LAPTOP GRAPHICAL ENVIRONMENT - KDE Plasma 6 + Wayland
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
}
