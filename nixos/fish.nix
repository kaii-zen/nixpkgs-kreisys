{ config, pkgs, ... }:

let
  cfg = config.programs.fish;
in {
  programs.fish = {
    enable = true;
    promptInit = ''
      set -g default_user kreisys
      set -g theme_color_scheme base16-dark
      set -g theme_nerd_fonts yes
    '';

    shellInit = ''
      fish_vi_key_bindings
      function fish_user_key_bindings
        for mode in insert default visual
          bind -M $mode \cf forward-char
          bind -M $mode \ca beginning-of-line
          bind -M $mode \cx end-of-line
        end
      end
    '';
  };

  environment.systemPackages = with pkgs; [ iterm2-integration bobthefish docker-completions git ];

  environment.shells = [
    "/run/current-system/sw/bin/fish"
    "/var/run/current-system/sw/bin/fish"
    "${pkgs.fish}/bin/fish"
  ];

}
