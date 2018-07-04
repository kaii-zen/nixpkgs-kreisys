extraArgs:

{ module, ... }:

with builtins;

let
  inherit (import <nixpkgs> {}) lib runCommand;
  projectRoot = ../../.;
  projectName = baseNameOf projectRoot;
  testName = baseNameOf (getEnv "PWD");
  nixpkgs = path {
    path = projectRoot;
    filter = path: _: match "^.*\.tfstate.*$" path == null && match "^.*/\.git" path == null;
  };
in [(module "test" (lib.recursiveUpdate {
  source = nixpkgs + "/nixos/tests";
  display_name = ''''${title("${testName} test")}'';
  tags = [{
    key = "consul:dc";
    value = "${projectName}-${testName}-test";
    propagate_at_launch = true;
  }];
  nixexprs = runCommand "${testName}-test-config" {
    src = nixpkgs;
  } ''
    mkdir -p $out
    cp -r $src $out/${projectName}
    cat <<EOF > $out/configuration.nix
    {
    imports = [ ./${projectName}/nixos/modules ./${projectName}/nixos/tests/${testName}/configuration.nix ];
    }
    EOF
  '';
} extraArgs))]
