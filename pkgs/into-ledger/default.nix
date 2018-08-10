{ stdenv, buildGo19Package }:

buildGo19Package rec {
  name = "into-ledger-${version}";
  version = "0.0.1";
  rev = "v${version}";

  goPackagePath = "github.com/manishrjain/into-ledger";

  src = builtins.fetchGit {
    url  = https:// + goPackagePath;
    rev = "19299e1de173e826a9f6bf30b3f05254ba521667";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Most efficient and accurate tool to categorize and import expenses into ledger";
    homepage = https:// + goPackagePath;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mit;
  };
}
