{ lib, config, ... }:

let
  consulCfg = config.services.consul;
  zerotierCfg = config.services.zerotierone;
in lib.mkIf (consulCfg.enable && zerotierCfg.enable) {
  services.consul.advertise_addr_wan =  ''{{ GetInterfaceIP "zt0" }}'';

  systemd.services.consul = {
    bindsTo = [ "sys-subsystem-net-devices-zt0.device" ];
    after   = [ "sys-subsystem-net-devices-zt0.device" ];
  };
}

