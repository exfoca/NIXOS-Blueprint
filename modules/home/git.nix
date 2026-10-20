{
  config,
  pkgs,
  lib,
  gitUserName,
  gitUserEmail,
  gpgPublicKeyFingerprint,
  ...
}:

{
  # ==========================================================================
  # GIT
  #
  # Identity is centralized in flake.nix to avoid scattering personal data across
  # modules. GPG signing is optional.
  # ==========================================================================

  programs.git = {
    enable = true;

    signing = {
      key = gpgPublicKeyFingerprint;
      format = "openpgp";
      signByDefault = gpgPublicKeyFingerprint != null;
    };

    settings = {
      user = {
        name = gitUserName;
        email = gitUserEmail;
      };

      init.defaultBranch = "main";

      pull.rebase = false;
      push.autoSetupRemote = true;

      core = {
        editor = "nano";
        autocrlf = "input";
      };

      fetch.prune = true;

      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };

      rerere.enabled = true;

      # For multiple GitHub identities, combine aliases in ssh.nix with
      # `settings.url.<base>.insteadOf`. The public repository contains no rules
      # tied to real usernames or organizations.

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        df = "diff";
        lg = "log --oneline --graph --decorate --all";

        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
        amend = "commit --amend --no-edit";
        undo = "reset --soft HEAD~1";

        add-commit = "!git add -A && git commit -m";
        who = "shortlog -s --all --no-merges";
        tree = "log --graph --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset'";
        pf = "push --force-with-lease";
        clean-branches = "!git branch --merged | grep -v \"\\*\\|main\\|develop\" | xargs -r -n 1 git branch -d";
      };
    };
  };
}
