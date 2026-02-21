{ config, lib, pkgs, ... }:

let
  nvidia_580 = config.boot.kernelPackages.nvidia_x11.overrideAttrs (oldAttrs: rec {
    version = "580.126.09";
    src = pkgs.fetchurl {
      url = "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run";
      sha256 = "sha256-TKxT5I+K3/Zh1HyHiO0kBZokjJ/YCYzq/QiKSYmG7CY=";
    };
  });
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = false;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; 
    package = nvidia_580;
  };

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    
    extraModprobeConfig = ''
      options nvidia NVreg_IgnoreGCCCheck=1
    '';
  };

  nixpkgs.config.nvidia.acceptLicense = true;
}
