{ module, ... }:

let inherit (import <nixpkgs> {}) runCommand; in
[(module "test" {
  source = ../.;
  display_name = "Consul Test";
  count = 3;
  tags = [{
    key = "consul:dc";
    value = "va-test";
    propagate_at_launch = true;
  }];
  nixexprs = runCommand "consul-test-config" {} ''
    mkdir -p $out
    cp -r ${../../../.} $out/nixpkgs-kreisys
    cat <<EOF > $out/configuration.nix
    {
      imports = [ ./nixpkgs-kreisys/nixos/modules ./nixpkgs-kreisys/nixos/tests/consul/configuration.nix ];
    }
    EOF
  '';
})]
