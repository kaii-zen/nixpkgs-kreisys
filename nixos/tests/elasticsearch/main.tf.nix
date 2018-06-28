{ module, ... }:

let inherit (import <nixpkgs> {}) runCommand; in
[(module "test" {
  source = ../.;
  display_name = "Elasticsearch Test";
  count = 1;
  instance_type = "m4.large";
  tags = [{
    key = "consul:dc";
    value = "va-test";
    propagate_at_launch = true;
  }];
  nixexprs = runCommand "elasticsearch-test-config" {} ''
    mkdir -p $out
    cp -r ${../../../.} $out/nixpkgs-kreisys
    cat <<EOF > $out/configuration.nix
    {
      imports = [ ./nixpkgs-kreisys/nixos/modules ./nixpkgs-kreisys/nixos/tests/elasticsearch/configuration.nix ];
    }
    EOF
  '';
})]
