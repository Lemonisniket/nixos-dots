{ ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    listenOptions = [ "/var/run/docker.sock" ];
    extraOptions = "--default-ulimit nofile=65536:1048576";
  };

  systemd.services.docker.serviceConfig = {
    LimitNOFILE = 1048576;
  };

  systemd.sockets.docker.wantedBy = [ "sockets.target" ];

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
