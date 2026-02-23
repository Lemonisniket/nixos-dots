{ pkgs, ... }:

let
setwallp = pkgs.writeShellScriptBin "setwallp" ''
    if [ -z "$1" ]; then
        echo -e "  \033[1;32m󰸉\033[0m  \033[1mUsage:\033[0m setwallp \033[3mpath/to/image\033[0m"
	exit 1
    fi

    mkdir -p "$HOME/.config/hypr"
    
    cp "$1" "$HOME/.config/hypr/wallpaper.current"
    
    BG_PATH="$HOME/.config/hypr/wallpaper.current"

    if ! pgrep -x "swww-daemon" > /dev/null; then
        ${pkgs.swww}/bin/swww-daemon &
        sleep 0.5
    fi

    ${pkgs.swww}/bin/swww img "$BG_PATH" --transition-type center
    ${pkgs.matugen}/bin/matugen image "$BG_PATH" --type scheme-tonal-spot
    
    pkill -USR1 kitty
    pkill -SIGUSR2 waybar || true
    ${pkgs.hyprland}/bin/hyprctl reload
  '';
in
{
  home.packages = [ 
    pkgs.matugen 
    pkgs.swww
    setwallp
  ];

  xdg.configFile."matugen/config.toml".text = ''
    [config]
    default_mode = 'dark'

    [templates.hyprland]
    input_path = '/home/lemon/.config/matugen/templates/hyprland.conf'
    output_path = '/home/lemon/.config/hypr/colors.conf'

    [templates.kitty]
    input_path = '/home/lemon/.config/matugen/templates/kitty.conf'
    output_path = '/home/lemon/.config/kitty/colors.conf'

    [templates.quickshell]
    input_path = '/home/lemon/.config/matugen/templates/quickshell.qml'
    output_path = '/home/lemon/nixconf/configs/quickshell/Theme.qml'

    [templates.wofi]
    input_path = '/home/lemon/.config/matugen/templates/wofi.css'
    output_path = '/home/lemon/.config/wofi/style.css'
  '';

  xdg.configFile."matugen/templates/kitty.conf".text = ''
    background            #{{colors.surface.default.hex_stripped}}
    foreground            #{{colors.on_surface.default.hex_stripped}}
    cursor                #{{colors.primary.default.hex_stripped}}
    selection_background  #{{colors.surface_variant.default.hex_stripped}}
    selection_foreground  #{{colors.on_surface_variant.default.hex_stripped}}

    # Black
    color0  #{{colors.surface.default.hex_stripped}}
    color8  #{{colors.outline.default.hex_stripped}}

    # Red
    color1  #{{colors.error.default.hex_stripped}}
    color9  #{{colors.error_container.default.hex_stripped}}

    # Green
    color2  #{{colors.primary.default.hex_stripped}}
    color10 #{{colors.primary_fixed_dim.default.hex_stripped}}

    # Yellow
    color3  #{{colors.tertiary.default.hex_stripped}}
    color11 #{{colors.tertiary_container.default.hex_stripped}}

    # Blue 
    color4  #{{colors.primary_fixed.default.hex_stripped}}
    color12 #{{colors.inverse_primary.default.hex_stripped}}

    # Magenta
    color5  #{{colors.secondary.default.hex_stripped}}
    color13 #{{colors.secondary_container.default.hex_stripped}}

    # Cyan
    color6  #{{colors.primary_container.default.hex_stripped}}
    color14 #{{colors.on_primary_container.default.hex_stripped}}

    # White
    color7  #{{colors.on_surface.default.hex_stripped}}
    color15 #{{colors.on_surface_variant.default.hex_stripped}}
'';

  xdg.configFile."matugen/templates/hyprland.conf".text = ''
    $primary = {{colors.primary.default.hex_stripped}}
    $surface = {{colors.surface.default.hex_stripped}}
    $accent = {{colors.tertiary.default.hex_stripped}}
  '';

  xdg.configFile."matugen/templates/quickshell.qml".text = ''
    import QtQuick
    pragma Singleton

    QtObject {
      readonly property color primary: "#{{colors.primary.default.hex_stripped}}"
      readonly property color fgPrimary: "#{{colors.on_primary.default.hex_stripped}}"
      readonly property color surface: "#{{colors.surface.default.hex_stripped}}"
      readonly property color fgSurface: "#{{colors.on_surface.default.hex_stripped}}"
      readonly property color error: "#{{colors.error.default.hex_stripped}}"
    }
  '';

  xdg.configFile."matugen/templates/wofi.css".text = '' 
  window {
      background-color: #{{colors.surface.default.hex_stripped}};
      border-radius: 24px;
      border: 2px solid #{{colors.surface_variant.default.hex_stripped}};
      font-family: "Google Sans Flex";
  }

  #input {
      margin: 16px;
      padding: 12px;
      border-radius: 12px;
      background-color: #{{colors.surface_container.default.hex_stripped}};
      color: #{{colors.on_surface.default.hex_stripped}};
      border: none;
  }

  #inner-box {
      margin: 8px;
  }

  #entry {
      padding: 12px;
      margin: 4px;
      border-radius: 16px;
  }

  #entry:selected {
      background-color: #{{colors.primary_container.default.hex_stripped}};
  }

  #text {
      color: #{{colors.on_surface.default.hex_stripped}};
  }

  #entry:selected #text {
      color: #{{colors.on_primary_container.default.hex_stripped}};
  }

  #img {
      margin-right: 12px;
      width: 24px;
      height: 24px;
  }
  '';
}
