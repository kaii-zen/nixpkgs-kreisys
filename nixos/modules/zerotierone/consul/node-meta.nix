{ lib, config, ... }:

let inherit (config.services) consul zerotierone;
in lib.mkIf (consul.enable && zerotierone.enable) {
  systemd = {
    services.consul-zerotier-id = {
      description = "Publish Zerotier node id to Consul node metadata";
      wantedBy    = [ "multi-user.target" ];
      path        = [ config.services.consul.package ];

      script      = ''
        cat /var/lib/zerotier-one/identity.public | cut -d: -f1 | xargs -I% echo '{ "node_meta": { "zerotier-id": "%" } }' > /etc/consul.d/node-meta-zerotier-id.json
        consul reload
      '';

      serviceConfig.Type = "oneshot";
    };

    paths.consul-zerotier-id = {
      wantedBy = [ "multi-user.target" ];
      pathConfig.PathModified = "/var/lib/zerotier-one/identity.public";
    };
  };
}
