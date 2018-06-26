{
  services.elasticsearch.enable = true;
  services.consul = {
    enable = true;
    server = true;
    translate_wan_addrs = false;
    advertise_addr_wan = null;
    datacenter = "va-test";
    extraConfig.bootstrap_expect = 3;
  };
}
