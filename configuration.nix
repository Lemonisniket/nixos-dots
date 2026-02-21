# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix

    ./modules/system/main.nix
    ./modules/system/boot.nix
    ./modules/system/net.nix
    ./modules/system/tune.nix
    ./modules/system/virt.nix
    ./modules/system/kernel/main.nix
    ./modules/system/nvidia.nix

    ./modules/apps/software.nix
  ];

  users.users.lemon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "kvm" ];
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  systemd.settings.Manager.DefaultTimeoutStopSec = "2s";
  nixpkgs.config.checkAssertions = false;

  system.stateVersion = "25.11"; 
}
