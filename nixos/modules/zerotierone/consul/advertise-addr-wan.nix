{ lib, config, ... }:

let consulCfg = config.services.consul;
in with lib; {
  services.consul.advertise_addr_wan = mkIf consulCfg.enable ''{{ GetInterfaceIP "zt0" }}'';

  systemd.services.consul = mkIf consulCfg.enable {
    bindsTo = [ "sys-subsystem-net-devices-zt0.device" ];
    after   = [ "sys-subsystem-net-devices-zt0.device" ];
  };
}
