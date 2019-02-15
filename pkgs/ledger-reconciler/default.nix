{ mkYarnPackage }:

mkYarnPackage {
  src = builtins.fetchTarball https://github.com/marvinpinto/ledger-reconciler/archive/v0.3.0.tar.gz;
  preBuild = ''
    chmod +x index.js
  '';
}
