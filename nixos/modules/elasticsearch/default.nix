{ lib, pkgs, config, ... }:

let
  cfg = config.services.elasticsearch;
in with lib; {
  imports = [ ./consul ];

  options.services.elasticsearch.discovery = mkOption {
    type = types.attrs // {
      merge = _: foldl' (res: def: recursiveUpdate res def.value) {};
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 9200 9300 ];

    #fileSystems."${cfg.dataDir}" = {
    #  autoFormat = true;
    #  fsType = "ext4";
    #  device = "/dev/xvde";
    #};

    #systemd.services.elasticsearch.unitConfig.RequiresMountsFor = cfg.dataDir;

    services.elasticsearch = {
      package = pkgs.elasticsearch6;
      listenAddress = "0.0.0.0";
      #plugins = optional consulCfg.enable  pkgs.elasticsearchPlugins.consul_discovery_es6;
      cluster_name = "test";
      discovery.zen.minimum_master_nodes = 3;

      extraConf = ''
        gateway.expected_nodes: 3

        discovery: ${builtins.toJSON cfg.discovery}
      '';

      #  discovery:
      #    ${optionalString consulCfg.enable ''
      #    consul: ${builtins.toJSON {
      #      service-names = [ "elasticsearch" ];
      #      tag = "node";
      #    }}
      #    ''}
      #    zen:
      #      minimum_master_nodes: 3
      #      ${optionalString consulCfg.enable ''
      #      hosts_provider: consul
      #      ''}
      #'';
    };

    #services.consul = mkIf consulCfg.enable {
    #  extraConfig.enable_script_checks = true;
    #  services = [{
    #    id = "elasticsearch_service";
    #    name = "elasticsearch";
    #    tags = [ "service" ];
    #    inherit (cfg) port;
    #    check = {
    #      args =  [ "${pkgs.curl}/bin/curl" "-s" "localhost:${toString cfg.port}" ];
    #      interval = "10s";
    #    };
    #  } {
    #    id = "elasticsearch_node";
    #    name = "elasticsearch";
    #    tags = [ "node" ];
    #    port = cfg.tcp_port;
    #    check = {
    #      args =  [ "${pkgs.netcat}/bin/nc" "-zv" "localhost" (toString cfg.tcp_port) ];
    #      interval = "10s";
    #    };
    #  }];
    #};
  };
}
