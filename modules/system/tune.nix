{ lib, ... }:

  {
  zramSwap = {
    enable = true;
    algorithm = "lzo-rle";
    memoryPercent = 150; 
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 50;
    "vm.page-cluster" = 0;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;

    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
}
