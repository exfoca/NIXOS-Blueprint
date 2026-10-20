{ ... }:

{
  # ==========================================================================
  # FLATPAK - MINIMAL EXAMPLE SET
  #
  # `services.flatpak.packages` comes from the `nix-flatpak` input (see flake.nix),
  # not the native nixpkgs Flatpak module. Keep only a few apps enabled to avoid
  # large downloads during the first switch.
  #
  # A larger catalog, NOT imported by default, is available at:
  #   examples/flatpak-extra.nix
  # ==========================================================================

  services.flatpak.enable = true;

  services.flatpak.packages = [
    "org.mozilla.firefox"
    "org.keepassxc.KeePassXC"
    "com.github.tchx84.Flatseal"
    "io.github.flattool.Warehouse"
    "org.videolan.VLC"
    "com.github.jeromerobert.pdfarranger"
  ];
}
