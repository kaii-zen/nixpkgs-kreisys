{ lib, pkgs, config, ... }:

let
  esCfg = config.services.elasticsearch;
  consulCfg = config.services.consul;

in with lib; {

  config = mkIf (esCfg.enable && consulCfg.enable) {

    services.elasticsearch = {
      plugins = [ pkgs.elasticsearchPlugins.consul_discovery_es6 ];
      discovery = {
        zen.hosts_provider = "consul";
        consul = {
          service-names = [ "elasticsearch" ];
          tag = "node";
        };
      };
    };

    services.consul = {
      extraConfig.enable_script_checks = true;
      services = [{
        id = "elasticsearch_service";
        name = "elasticsearch";
        tags = [ "service" ];
        inherit (esCfg) port;
        check = {
          args =  [ "${pkgs.curl}/bin/curl" "-s" "localhost:${toString esCfg.port}" ];
          interval = "10s";
        };
      } {
        id = "elasticsearch_node";
        name = "elasticsearch";
        tags = [ "node" ];
        port = esCfg.tcp_port;
        check = {
          args =  [ "${pkgs.netcat}/bin/nc" "-zv" "localhost" (toString esCfg.tcp_port) ];
          interval = "10s";
        };
      }];
    };
  };
}
