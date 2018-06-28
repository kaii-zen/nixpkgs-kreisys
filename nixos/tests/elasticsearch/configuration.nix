let capacity = 1; in
{
  services = {
    elasticsearch = {
      enable = true;
      version = 6;
      discovery.zen.minimum_master_nodes = capacity;
    };

    consul = {
      enable = true;
      server = true;
      translate_wan_addrs = false;
      advertise_addr_wan = null;
      datacenter = "va-test";
      extraConfig.bootstrap_expect = capacity;
    };
  };
}
