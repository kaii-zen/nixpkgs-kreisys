{ lib, config, pkgs, ... }:

let cfg = config.services.consul;
in with lib;
{
  options.services.consul = with types; with builtins; {
    services = mkOption {
      default = [ ];
      type = listOf attrs;
      description = ''
        Service definitions
      '';
    };

    checks = mkOption {
      default = [ ];
      type = listOf attrs;
      description = ''
        Check definitions
      '';
    };

    advertise_addr_wan = mkOption {
      default = readFile (fetchurl http://169.254.169.254/2018-03-28/meta-data/public-ipv4);
      type = string;
      description = ''
        IP address to publish to federated nodes.
      '';
    };


    advertise_addr = mkOption {
      default = readFile (fetchurl http://169.254.169.254/2018-03-28/meta-data/local-ipv4);
      type = string;
      description = ''
        IP address to publish to nodes in the same datacenter.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8300 8301 8302 ];

    services = {
      dnsmasq = {
        enable = true;
        extraConfig = "server=/consul/127.0.0.1#8600";
      };

      consul = {
        extraConfig = with builtins; {
          retry_join = ["provider=aws tag_key=Consul tag_value=Legacy"];
          datacenter = "us-east-1";
          acl_default_policy = "allow";
          enable_script_checks = true;
          #translate_wan_addrs = true;
          log_level = "INFO";
          protocol = 3;
          inherit (cfg) services checks advertise_addr advertise_addr_wan;
        };
      };
    };
  };
}
