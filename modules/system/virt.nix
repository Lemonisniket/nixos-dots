{ ... }: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    listenOptions = [ "/var/run/docker.sock" ];
  };

  systemd.sockets.docker.wantedBy = [ "sockets.target" ];

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
