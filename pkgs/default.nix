self: super: with super; rec {
  inherit (callPackage ./terraform {})
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

  terraform-docs = callPackage ./terraform-docs {};

  inherit (callPackage ./fish {})
    iterm2-integration
    docker-completions
    bobthefish
    ;

  consul = callPackage ./consul {};
  consulate = callPackage ./consulate {};

  into-ledger = callPackage ./into-ledger {};
  ledger-reconciler = callPackage ./ledger-reconciler {};

  dep2nix = callPackage ./dep2nix {};

  elasticsearch = callPackage ./elasticsearch { };
  elasticsearch2 = callPackage ./elasticsearch/2.x.nix { };
  elasticsearch5 = callPackage ./elasticsearch/5.x.nix { };
  elasticsearch6 = callPackage ./elasticsearch/6.x.nix { };

  elasticsearchPlugins = recurseIntoAttrs (
    callPackage ./elasticsearch/plugins.nix { }
  );

  nvim = callPackage ./nvim {};
}
