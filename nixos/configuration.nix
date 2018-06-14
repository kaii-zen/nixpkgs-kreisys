{ pkgs, ... }:

{
  imports = [ ./user.nix ./fish.nix ];
  environment.systemPackages = [ pkgs.nvim ];
}
