{ lib, pkgs, config, ... }:

let inherit (config.services) consul zerotierone;
in lib.mkIf (consul.enable && zerotierone.enable) {
  services.consul.checks = map (netId: {
    id     = "zerotier-net-${netId}";
    name   = "Zerotier One Network (ID: ${netId})";
    notes  = "A Systemd timer submits the connection status of this network every 15s";
    ttl    = "30s";
  }) zerotierone.joinNetworks;

  systemd = {

    # Create a timer job for each network that we are supposed to connect to
    timers.consul-zerotier-net-healthcheck-responder = {
      wantedBy    = [ "multi-user.target" ];
      timerConfig = {
        OnCalendar  = "*:*:0/10";
        AccuracySec = "1sec";
      };
    };

    services.consul-zerotier-net-healthcheck-responder = {
      description = "Send status of Zerotier Networks to their respective Consul healthchecks";
      wantedBy    = [ "multi-user.target" ];
      path        = with pkgs; [ curl jq zerotierone.package ];

      script      = ''
        zerotier-cli listnetworks -j | jq -r '.[] | "\(.id) \(.status)"' | while read id output; do
          status=
          case $output in
            ACCESS_DENIED) status=critical ;;
            *) status=passing ;;
          esac

          echo "{ \"Status\": \"$status\", \"Output\": \"$output\" }" | curl --silent --request PUT --data @- http://localhost:8500/v1/agent/check/update/zerotier-net-$id
        done
      '';

      serviceConfig.Type = "oneshot";
    };
  };
}
