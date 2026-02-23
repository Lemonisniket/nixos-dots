{
  description = "general flake.nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tkg-src = { url = "github:Frogging-Family/linux-tkg"; flake = false; };
    linux-src = { url = "github:gregkh/linux?ref=linux-6.19.y"; flake = false; };
    google-fonts-src = { url = "github:LineageOS/android_external_google-fonts_google-sans-flex"; flake = false; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    quickshell-src = { url = "git+https://git.outfoxxed.me/quickshell/quickshell/"; flake = true; };
  };
  outputs = { self, nixpkgs, home-manager, google-fonts-src, quickshell-src,... }@inputs:
  let
    system = "x86_64-linux";
    googleSansOverlay = final: prev: {
      google-sans-flex = prev.stdenvNoCC.mkDerivation {
        pname = "google-sans-flex";
        version = "git";
        src =  google-fonts-src;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp *.ttf $out/share/fonts/truetype/
        '';
        dontBuild = true;
        meta = with prev.lib; {
          description = "Google Sans Flex variable font";
          license = licenses.ofl;
          platforms = platforms.all;
        };
      };
    };
    quickshellOverlay = final: prev: {
       quickshell = quickshell-src.packages.${system}.default;
    };
    mkSystem = perfMode:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit perfMode inputs; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = [ googleSansOverlay quickshellOverlay]; }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
  in {
    nixosConfigurations = {
      desktp = mkSystem false;
      desktp-perf = mkSystem true;
    };
    overlays.google-sans-flex = googleSansOverlay;
  };
}
