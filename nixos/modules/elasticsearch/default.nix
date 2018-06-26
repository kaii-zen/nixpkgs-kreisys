{ lib, pkgs, config, ... }:

let
  cfg = config.services.elasticsearch;
in with lib; {
  imports = [ ./consul.nix ];

  options.services.elasticsearch.discovery = mkOption {
    type = types.attrs // {
      merge = _: foldl' (res: def: recursiveUpdate res def.value) {};
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 9200 9300 ];
    services.elasticsearch = {
      package = pkgs.elasticsearch6;
      listenAddress = "0.0.0.0";
      discovery.zen.minimum_master_nodes = 3;

      extraConf = ''
        gateway.expected_nodes: 3
        discovery: ${builtins.toJSON cfg.discovery}
      '';
    };
  };
}
