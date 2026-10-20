{
  config,
  pkgs,
  lib,
  userName,
  ...
}:

{
  imports = [
    ./cli.nix
    ./git.nix
    ./gpg.nix
    ./gaming.nix
    ./packages.nix
    ./plasma.nix
    ./vscode.nix
    ./ssh.nix
  ];

  # `userName` comes from the PUBLIC CUSTOMIZATION block in flake.nix.
  home.username = userName;
  home.homeDirectory = "/home/${userName}";

  # Keep this value at the version used for the initial Home Manager installation.
  # Updating inputs does not imply changing stateVersion.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # To see every path, run: echo $PATH
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/Scripts"
  ];

  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  fonts.fontconfig.enable = true;
}
