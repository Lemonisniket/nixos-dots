{ pkgs, ... }:

{
  imports = [
    ./monitors.nix
    ./binds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "exec-once" = [
        "waybar"
        "wl-paste --type text --watch cliphist store"
        "swww-daemon"
        "set-wallpaper ~/.config/hypr/wallpaper.current"
      ];

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle"; 
        follow_mouse = 1;
        sensitivity = 0; 
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 12;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(00000044)";
        };
      };

      animations = {
        enabled = true;
        bezier = "md3_decel, 0.05, 0.7, 0.1, 1";
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "workspaces, 1, 3.5, md3_decel, slide"
        ];
      };
    };

    extraConfig = ''
      source = ~/.config/hypr/colors.conf

      general {
          col.active_border = rgb($primary) rgb($accent) 45deg
          col.inactive_border = rgb($surface)
      }
    '';
  };
}
