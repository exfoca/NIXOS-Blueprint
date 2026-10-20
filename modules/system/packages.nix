{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # SYSTEM PACKAGES - Packages installed globally on the system
  # ==========================================================================

  environment.systemPackages = with pkgs; [

    # ------------------------------------------------------------------------
    # Hardware diagnostics
    # ------------------------------------------------------------------------

    pciutils # List PCI devices (lspci)
    usbutils # List USB devices (lsusb)
    lshw # Detailed hardware listing
    mesa-demos # Graphics demos (glxinfo, etc.)

    # ------------------------------------------------------------------------
    # System
    # ------------------------------------------------------------------------

    util-linux # Essential Linux utilities (fdisk, mount, etc.)

    # ------------------------------------------------------------------------
    # Networking
    # ------------------------------------------------------------------------

    curl # Data transfer via URL
    wget # File downloads
    iproute2 # Networking tools (ip, ss, etc.)
    inetutils # Network utilities (ping, traceroute, etc.)

    # ------------------------------------------------------------------------
    # Kernel / modules
    # ------------------------------------------------------------------------

    kmod # Kernel module management (modprobe, lsmod)

    # ------------------------------------------------------------------------
    # Disk and storage
    # ------------------------------------------------------------------------

    gparted # Graphical partition editor
    smartmontools # Disk monitoring (SMART)
    lm_sensors # Temperature and voltage monitoring
    dc3dd # Verified data copying

    # ------------------------------------------------------------------------
    # Security
    # ------------------------------------------------------------------------

    audit # System auditing
    clamav # Antivirus (file scanning)
    veracrypt # Disk/file encryption

    # ------------------------------------------------------------------------
    # Virtualization
    # ------------------------------------------------------------------------

    virtualbox # VirtualBox (virtual machine manager)

    # ------------------------------------------------------------------------
    # Archives
    # ------------------------------------------------------------------------

    unzip # Extract .zip files
    p7zip # 7z archiver/extractor
    unrar # Extract .rar files

    # ------------------------------------------------------------------------
    # Development
    # ------------------------------------------------------------------------

    gnumake # Build tool (make)

    # ------------------------------------------------------------------------
    # Basic editors
    # ------------------------------------------------------------------------

    nano # Simple text editor
  ];
}
