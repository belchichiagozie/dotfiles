# ~/dotfiles/flake.nix
{
  description = "SNAIL ThinkPad Desktop Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {self, nixpkgs, home-manager, plasma-manager, ... }: {
    nixosConfigurations.SNAIL = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.belchi = {
            imports = [
              ./home.nix
              plasma-manager.homeModules.plasma-manager
            ];
          };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
