{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    options = lib.mkForce [ 
      "compression=zstd" 
      "background_compression=zstd"
      "discard" 
      "noatime" 
      "str_hash=siphash"
      "metadata_checksum=xxhash"
      "data_checksum=xxhash"
      "promote_whole_nodes"
      "x-initrd.mount"
    ];
  };

  fileSystems."/boot" = {
    options = lib.mkForce [ 
      "umask=0077"
      "noatime"
      "flush"
    ];
  };

  services.fstrim.enable = lib.mkDefault true;
}
