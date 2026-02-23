{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "CaskaydiaCove Nerd Font";
      font_size = 12;
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";

      background_opacity = "0.85";
      dynamic_background_opacity = "yes";

      window_padding_width = 10;

      shell = "fish";
    };

    extraConfig = ''
      include colors.conf
    '';
  };
}
