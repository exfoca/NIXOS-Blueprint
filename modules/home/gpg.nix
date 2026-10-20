{
  pkgs,
  lib,
  gpgPublicKeyFingerprint,
  ...
}:

{
  # ==========================================================================
  # GPG
  #
  # The configuration accepts only an optional public fingerprint.
  # The private key must exist only in the local keyring and never in Git.
  # ==========================================================================

  programs.gpg = {
    enable = true;

    mutableKeys = true;
    mutableTrust = true;

    settings = {
      keyid-format = "0xlong";
      with-fingerprint = true;
    }
    // lib.optionalAttrs (gpgPublicKeyFingerprint != null) {
      default-key = gpgPublicKeyFingerprint;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableSshSupport = false;

    # The TTL is renewed on each use, capped at eight hours from the original
    # passphrase entry.
    defaultCacheTtl = 7200;
    maxCacheTtl = 28800;

    pinentry.package = pkgs.pinentry-curses;
  };
}
