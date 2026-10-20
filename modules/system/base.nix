{
  config,
  pkgs,
  lib,
  timeZone,
  defaultLocale,
  ...
}:

{
  # ==========================================================================
  # BOOT
  # ==========================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ==========================================================================
  # ZRAM
  # ==========================================================================

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "lz4";
  };

  # ==========================================================================
  # SYSTEM LIMITS
  #
  # 524288 FDs is a high value suitable for a workstation/dev environment with many
  # processes, containers, browsers, and build tools. Lower it if you do not need
  # that headroom; it is not a NixOS requirement. `domain = "*"` applies the limit
  # to every user covered by PAM, including root. Use a specific user/group if you
  # want to scope this tuning more narrowly.
  # ==========================================================================

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = 524288;
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = 524288;
    }
  ];

  # ==========================================================================
  # NIX
  # ==========================================================================

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ==========================================================================
  # CLOCK
  #
  # Use the global public pool so the example is not tied to a specific region.
  # ==========================================================================

  services.chrony = {
    enable = true;
    servers = [
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
      "3.pool.ntp.org"
    ];
    extraConfig = ''
      makestep 1.0 3
    '';
  };

  # ==========================================================================
  # TIME / LOCALE
  # ==========================================================================

  time.timeZone = timeZone;

  i18n.defaultLocale = defaultLocale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = defaultLocale;
    LC_IDENTIFICATION = defaultLocale;
    LC_MEASUREMENT = defaultLocale;
    LC_MONETARY = defaultLocale;
    LC_NAME = defaultLocale;
    LC_NUMERIC = defaultLocale;
    LC_PAPER = defaultLocale;
    LC_TELEPHONE = defaultLocale;
    LC_TIME = defaultLocale;
  };

  services.printing.enable = true;
  documentation.nixos.enable = true;

  # Keep this value at the NixOS version used for the initial installation.
  # It controls defaults compatible with persistent state and should not be
  # increased automatically when updating nixpkgs.
  system.stateVersion = "26.05";
}
