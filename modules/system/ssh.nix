{
  config,
  pkgs,
  lib,
  userName,
  ...
}:

{
  # ==========================================================================
  # SSH SERVER
  # ==========================================================================

  services.openssh = {
    enable = true;

    # Port 22 is opened only because the SSH server is explicitly enabled.
    # Password login remains disabled; configure an authorized key before relying
    # on remote access.
    openFirewall = true;

    settings = {
      X11Forwarding = false;

      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;

      PermitRootLogin = "no";

      # Only the primary user declared in the flake may authenticate over SSH.
      AllowUsers = [ userName ];

      MaxAuthTries = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };

  # Additional protection against repeated SSH authentication attempts.
  services.fail2ban = {
    enable = true;

    jails.sshd.settings = {
      enabled = true;
      backend = "systemd";
      bantime = "10m";
      findtime = "10m";
      maxretry = 5;
    };
  };
}
