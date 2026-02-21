{ config, lib, pkgs, modulesPath, ...}:

{
 imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
 
  fileSystems."/" = 
   { device = "/dev/nvme0n1p2";
     fsType = "bcachefs";
   };

   fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

   nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
