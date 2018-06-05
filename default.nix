self: super: rec {
  inherit (super.callPackage ./pkgs/terraform {})
    terraform_0_8_5
    terraform_0_8
    terraform_0_9
    terraform_0_10
    terraform_0_10-full
    terraform_0_11
    terraform_0_11-full
    ;

  terraform = terraform_0_11;
  terraform-full = terraform_0_11-full;

  consul = super.callPackage ./pkgs/consul {};
}
