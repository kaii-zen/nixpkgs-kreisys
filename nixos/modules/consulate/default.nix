{ lib, pkgs, config, ... }:

let cfg = config.services.consulate; in
with lib; {
  options.services.consulate.enable = mkEnableOption "consulate";

  config = mkIf (cfg.enable && config.services.consul.enable) {

    networking.firewall.allowedTCPPorts = [ 8080 ];
    environment.systemPackages = [ pkgs.consulate ];

    systemd.services.consulate = {
      after = [ "consul.service" ];
      requires = [ "consul.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.consulate}/bin/consulate server";
    };
  };
}
