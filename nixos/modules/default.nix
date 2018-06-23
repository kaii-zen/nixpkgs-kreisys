{
  imports = [ ./consul ./zerotierone ];

  nixpkgs.overlays = [ (import ../../.).overlay ];
}
