{ pkgs, ... }:

{
  # Gaming tools kept in the shared user layer.
  home.packages = with pkgs; [
    r2modman
  ];
}
