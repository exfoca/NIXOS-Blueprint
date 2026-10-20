{ ... }:

{
  # OPTIONAL FLATPAK CATALOG
  #
  # This file is NOT imported by default. It demonstrates how to extend the minimal
  # set in modules/system/flatpak.nix. It requires the `nix-flatpak` module to be
  # available and `services.flatpak.enable = true` on the host (the minimal module
  # already provides both in this flake). Import it deliberately: the first activation
  # may download many runtimes and consume several GiB.

  services.flatpak.packages = [
    # Browsers
    "com.brave.Browser"
    "org.chromium.Chromium"

    # Security / privacy
    "com.github.ADBeveridge.Raider"
    "org.wireshark.Wireshark"

    # Office / documents
    "com.calibre_ebook.calibre"
    "org.gnumeric.Gnumeric"
    "org.gnome.Calculator"
    "md.obsidian.Obsidian"
    "com.github.marktext.marktext"
    "org.gnome.gitg"
    "io.github.diegoivan.pdf_metadata_editor"

    # Audio / video / media
    "org.audacityteam.Audacity"
    "org.fooyin.fooyin"
    "page.codeberg.grinka.Transition"

    # Graphics / design
    "org.inkscape.Inkscape"
    "org.upscayl.Upscayl"
    "org.gnome.design.Emblem"

    # Development
    "org.geany.Geany"
    "me.iepure.devtoolbox"
    "io.github.cleomenezesjr.Escambo"
    "org.sqlitebrowser.sqlitebrowser"
    "org.gaphor.Gaphor"
    "org.ghidra_sre.Ghidra"
    "com.github.marhkb.Pods"

    # Networking / connectivity
    "org.remmina.Remmina"
    "de.swsnr.turnon"
    "io.github.lo2dev.Echo"
    "com.github.bcedu.valasimplehttpserver"
    "org.qbittorrent.qBittorrent"

    # Gaming / Windows compatibility
    "net.lutris.Lutris"
    "com.usebottles.bottles"
    "com.github.k4zmu2a.spacecadetpinball"
    "studio.planetpeanut.Bobby"

    # System / utilities
    "org.gnome.baobab"
    "net.nokyan.Resources"
    "org.gtkhash.gtkhash"
    "io.github.cboxdoerfer.FSearch"
    "com.google.EarthPro"
    "com.ktechpit.glate"
    "io.github.lluciocc.Vish"
  ];
}
