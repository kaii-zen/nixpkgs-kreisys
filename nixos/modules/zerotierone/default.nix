{ lib, config, ... }:

with lib; {
  options.services.zerotierone.apiToken = mkOption {
    default = null;
    type = with types; nullOr string;
    description = ''
      If this is set and Consul is enabled, we will attempt to authorize
      any node any node whose access is currently denied. That allows new
      nodes to join the network automatically and as securely as Consul
      is configured.

      IMPORTANT: This is WIP so currently it WILL store the api_token in
                 the nix store so tread with caution. The plan is to
                 integrate with Vault at some point.
    '';
  };

  # We want the version from unstable because it supports joining networks
  disabledModules = [ "services/networking/zerotierone.nix" ];
  imports         = [ <nixos-unstable/nixos/modules/services/networking/zerotierone.nix> ./consul ];
}
