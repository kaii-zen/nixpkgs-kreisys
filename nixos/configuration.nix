{ pkgs, ... }:

{
  imports = [ ./user.nix ./fish.nix ./modules ];
  environment.systemPackages = [ pkgs.nvim ];
}
