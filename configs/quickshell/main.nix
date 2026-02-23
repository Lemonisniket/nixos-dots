{ pkgs, ... }:

{
  home.file.".config/quickshell/shell.qml".source = ./shell.qml;
  
  wayland.windowManager.hyprland.settings.exec-once = [ "quickshell" ];
}
