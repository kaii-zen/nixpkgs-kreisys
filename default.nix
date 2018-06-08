self: super: with super; rec {
  inherit (callPackage ./pkgs/terraform {})
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

  consul = callPackage ./pkgs/consul {};
  consulate = callPackage ./pkgs/consulate {};

  dep2nix = callPackage ./pkgs/dep2nix {};

  elasticsearch = callPackage ./pkgs/elasticsearch { };
  elasticsearch2 = callPackage ./pkgs/elasticsearch/2.x.nix { };
  elasticsearch5 = callPackage ./pkgs/elasticsearch/5.x.nix { };
  elasticsearch6 = callPackage ./pkgs/elasticsearch/6.x.nix { };

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ./pkgs/elasticsearch/plugins.nix { }
  );
}
