{
  imports = [ ./consul ./consulate ./zerotierone ./elasticsearch ];

  nixpkgs.overlays = [ (import ../../.).overlay ];
}
