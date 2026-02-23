{ pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";

  services.xserver = {
    enable = true;
    xkb = { layout = "us,ru"; options = "grp:alt_shift_toggle"; };
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  nix = {
    settings.auto-optimise-store = true;  
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  services.flatpak.enable = true;
  programs.ccache.enable = true;

  systemd.services."systemd-udev-settle".enable = false;
  
  services.journald.extraConfig = ''
    SystemMaxUse=50M
    MaxRetentionSec=3day
    RuntimeMaxUse=50M
  '';

  networking.firewall.enable = false;

  services.chrony.enable = true;

  security.pam.loginLimits = [
  { domain = "*"; item = "nofile"; type = "soft"; value = "65536"; }
  { domain = "*"; item = "nofile"; type = "hard"; value = "1048576"; }
];
}
