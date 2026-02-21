{ lib, ... }:

  {
  zramSwap = {
    enable = true;
    algorithm = "lzo-rle";
    memoryPercent = 150; 
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 140;
    "vm.page-cluster" = 0;
    
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_expire_centisecs" = 500;
    "vm.dirty_writeback_centisecs" = 100;

    "vm.vfs_cache_pressure" = 50;

    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    
    "kernel.sched_autogroup_enabled" = 1;
  };
}
