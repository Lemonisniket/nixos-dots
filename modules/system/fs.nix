{ lib, ...}:

  let 
    commonBtrfsOptions = [ "noatime" "compress=zstd:3" "ssd" "discard=async" "space_cache=v2" ];
    rootDevice = "/dev/nvme0n1p2";
    bootDevice = "/dev/nvme0n1p1";
  in
{
  fileSystems = {
    "/" = { 
      device = lib.mkForce rootDevice;
      fsType = "btrfs";
      options = [ "subvol=@nixos" ] ++ commonBtrfsOptions;
    };

    "/nix" = { 
      device = lib.mkForce rootDevice; 
      fsType = "btrfs"; 
      options = [ "subvol=@nix" ] ++ commonBtrfsOptions; 
    };

    "/home" = { 
      device = lib.mkForce rootDevice; 
      fsType = "btrfs"; 
      options = [ "subvol=@home" "nobarrier" "commit=60" ] ++ commonBtrfsOptions; 
    };

    "/var/log" = {
      device = lib.mkForce rootDevice;
      fsType = "btrfs";
      options = [ "subvol=@nixos" "noatime" "compress=zstd:5" "nobarrier" ];
    };

    "/boot" = {
      device = lib.mkForce bootDevice;
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
}
