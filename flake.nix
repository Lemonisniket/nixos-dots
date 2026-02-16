{
  description = "TKG kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    tkg-src = {
      url = "github:Frogging-Family/linux-tkg";
      flake = false;
    };

    linux-src = {
    url = "github:gregkh/linux/linux-6.19.y";
    flake = false;
    };

  };

  outputs = { self, nixpkgs, ... }@inputs: {
  nixosConfigurations = {
    desktp = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; perfMode = false; };
      modules = [ ./configuration.nix ]; 
    };

    "desktp-perf" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; perfMode = true; };
      modules = [ ./configuration.nix ];
    };
   };
  };
}
