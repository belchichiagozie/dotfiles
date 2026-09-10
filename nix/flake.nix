{
  description = "SNAIL ThinkPad Desktop Flake";

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

  outputs = {self, nixpkgs-unstable, nixpkgs-stable, home-manager, plasma-manager, nix-flatpak, ... }: {
    nixosConfigurations.SNAIL = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              stable = import nixpkgs-stable {
                system = prev.system;
                config.allowUnfree = true;
              };
              plasma6 = prev.stable.plasma6;
              sddm = prev.stable.sddm;
            })
          ];
        }

        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.belchi = {
            imports = [
              ./home.nix
              plasma-manager.homeModules.plasma-manager
              nix-flatpak.homeManagerModules.nix-flatpak
            ];
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
