{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "dep2nix";

  goPackagePath = "github.com/nixcloud/dep2nix";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo  = "dep2nix";
    rev   = "d94a118a9f8ae90cb4831f200cd66ff3d9deffab";
    sha256 = "1hf8gkbdk37la2qc8r9hs77vs2b3jh9z43c4d5f9fd89bwar392j";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Convert `Gopkg.lock` files from golang dep into `deps.nix`";
    license = licenses.bsd3;
    homepage = https://github.com/nixcloud.io/dep2nix;
  };

}
