{ config, pkgs, ... }:

{
  xdg.configFile."wofi/config".text = ''
    show=drun
    width=450
    height=500
    location=center
    always_parse_args=true
    show_all=false
    print_command=true
    insensitive=true
    allow_images=true
    hide_scroll=true
    parse_search=false
    cache_file=$HOME/.cache/wofi-drun
    style=/home/lemon/.config/wofi/style.css
  '';
}
