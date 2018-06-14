{ newScope }:

let
  callPackage = newScope self;

  self = rec {
    packagePlugin = { name, src }: callPackage ./package-plugin.nix { inherit name src; };

    bobthefish = let
      name = "bobthefish-${rev}";
      url = git://github.com/oh-my-fish/theme-bobthefish;
      rev = "f66bee227acbe1e744c8b609963d8bbf1fe87a3c";
      src = builtins.fetchGit { inherit url rev; };
    in packagePlugin { inherit name src; };

    iterm2-integration = packagePlugin {
      name = "iterm2-integration";
      src = ./iterm2-integration;
    };

    docker-completions = packagePlugin {
      name = "docker-completions";
      src = ./docker-completions;
    };

  };
in self
