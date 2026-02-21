{ ... }:

{
  networking.useNetworkd = true;
  networking.networkmanager.enable = false;

  systemd.network.wait-online.enable = false;
  systemd.services."systemd-networkd-wait-online".enable = false;

  systemd.network = {
    enable = true;
    networks."10-enp5s0" = {
      matchConfig.Name = "enp5s0";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = "no";
    };
  };

  services.resolved.enable = true;
}
