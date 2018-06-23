{ module, ... }:

let inherit (import <nixpkgs> {}) runCommand; in

[(module "test" {
  source = ../.;
  display_name = "Zerotier One Test";
  count = 1;
  nixexprs = runCommand "zerotier-one-config" {} ''
    mkdir -p $out
    cp -r ${../../../.} $out/nixpkgs-kreisys
    cat <<EOF > $out/configuration.nix
    {
      imports = [ ./nixpkgs-kreisys/nixos/modules ./nixpkgs-kreisys/nixos/tests/zerotierone/configuration.nix ];
    }
    EOF
  '';
})]
