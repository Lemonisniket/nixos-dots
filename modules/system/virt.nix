{ ... }: {
  virtualisation.docker = {
    enable = true;
    listenOptions = [ "/var/run/docker.sock" ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
