{
  imports = [ ./consul ./consulate ./zerotierone ];

  nixpkgs.overlays = [ (import ../../.).overlay ];
}
