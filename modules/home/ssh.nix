{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ==========================================================================
  # SSH AGENT
  # ==========================================================================

  services.ssh-agent.enable = true;

  # ==========================================================================
  # SSH CLIENT
  #
  # Private keys remain in ~/.ssh and are never version-controlled. The aliases
  # below are generic; create additional aliases only when you actually need to
  # separate identities by service or organization.
  # ==========================================================================

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "bitbucket.org" = {
        HostName = "bitbucket.org";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "gitlab.com" = {
        HostName = "gitlab.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "*" = {
        AddKeysToAgent = "yes";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 30;
      };
    };
  };
}
