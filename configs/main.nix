{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.lemon = { ... }: {
    imports = [
      ./hyprland/main.nix
      ./quickshell/main.nix
      ./matugen/main.nix
      ./theme/main.nix
      ./kitty/main.nix
      ./wofi/main.nix
    ];

    home.stateVersion = "25.11"; 
    
  };
}
