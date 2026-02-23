{ pkgs, ... }:

let
  shared-libs = with pkgs; [
    glib nspr nss dbus atk at-spi2-atk at-spi2-core 
    cups expat libxcb libxkbcommon libx11 
    libxcomposite libxdamage libxext 
    libxfixes libxrandr libgbm cairo 
    pango systemd alsa-lib gtk3 libGL libva mesa
  ];

  thorium = pkgs.buildFHSEnv {
    name = "thorium";
    targetPkgs = pkgs: shared-libs;
    runScript = "/home/lemon/thorium-browser/thorium";
  };
in
{
  environment.systemPackages = (with pkgs; [
    chromium
    thorium
    materialgram
    yandex-music
    gimp
    playerctl
    
    git git-lfs git-repo
    wget curl btop tree
    kitty fish starship fastfetch
    aria2 autossh chafa compsize
    lz4 zstd lzo
    
    ccache ninja perf llvm
    python3 modprobed-db
    distrobox
    
    virt-manager virt-viewer
    spice spice-gtk spice-protocol
    virtio-win win-spice
    
    gnome-extension-manager
    android-tools

    wofi
    hyprpaper
    grim
    slurp
    wl-clipboard
    matugen
    swww

    quickshell 
  ]);

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = shared-libs;

  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji
    liberation_ttf fira-code fira-code-symbols inter  nerd-fonts.geist-mono
    cantarell-fonts jetbrains-mono cascadia-code google-fonts google-sans-flex
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Google Sans" "Lexend" ];
    monospace = [ "GeistMono Nerd Fon" ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.fish.enable = true;

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
