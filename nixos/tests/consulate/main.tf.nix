{ module, ... }:

let inherit (import <nixpkgs> {}) runCommand; in
[(module "test" {
  source = ../.;
  display_name = "Consulate Test";
  nixexprs = runCommand "consulate-test-config" {} ''
    mkdir -p $out
    cp -r ${../../../.} $out/nixpkgs-kreisys
    cat <<EOF > $out/configuration.nix
    {
      imports = [ ./nixpkgs-kreisys/nixos/modules ./nixpkgs-kreisys/nixos/tests/consulate/configuration.nix ];
    }
    EOF
  '';
})]
