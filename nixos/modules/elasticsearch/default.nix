{ lib, pkgs, config, ... }:

let
  cfg = config.services.elasticsearch;
in with lib; {
  imports = [ ./consul.nix ];

  options.services.elasticsearch = with types; {
    version = mkOption {
      type = enum [ 5 6 ];
      default = 5;
    };

    discovery = mkOption {
      type = attrs // {
        merge = _: foldl' (res: def: recursiveUpdate res def.value) {};
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 9200 9300 ];
    services.elasticsearch = {
      package = with pkgs; with cfg; if version == 5 then elasticsearch5 else if version == 6 then elasticsearch6 else abort;
      listenAddress = "0.0.0.0";

      extraConf = ''
        discovery: ${builtins.toJSON cfg.discovery}
      '';
    };
  };
}
