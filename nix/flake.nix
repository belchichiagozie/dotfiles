{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager, plasma-manager, nix-flatpak, ... }:
  let
    sharedOverlays = [
      (final: prev: {
        stable = import nixpkgs-stable {
          system = prev.system;
          config.allowUnfree = true;
        };
      })
    ];

    mkHost = { hostModule, homeModule }: nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        hostModule
        ./modules/core.nix
        {
          nixpkgs.overlays = sharedOverlays;
        }
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.belchi = {
            imports = [
              ./home/common.nix
              homeModule
              plasma-manager.homeModules.plasma-manager
              nix-flatpak.homeManagerModules.nix-flatpak
            ];
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  in {
    nixosConfigurations = {
      SNAIL = mkHost {
        hostModule = ./hosts/SNAIL/configuration.nix;
        homeModule = ./home/snail.nix;
      };

      GIRAFFE = mkHost {
        hostModule = ./hosts/GIRAFFE/configuration.nix;
        homeModule = ./home/giraffe.nix;
      };
    };
  };
}
