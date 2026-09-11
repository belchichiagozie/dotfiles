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
            })

            (final: prev: {
              kdePackages = prev.kdePackages // {
                plasma-workspace = let
                  basePkg = prev.kdePackages.plasma-workspace;

                  xdgdataPkg = final.stdenv.mkDerivation {
                    name = "${basePkg.name}-xdgdata";
                    buildInputs = [ basePkg ];
                    dontUnpack = true;
                    dontFixup = true;
                    dontWrapQtApps = true;
                    installPhase = ''
                      mkdir -p $out/share
                      ( IFS=:
                        for DIR in $XDG_DATA_DIRS; do
                          if [[ -d "$DIR" ]]; then
                            cp -r $DIR/. $out/share/
                            chmod -R u+w $out/share
                          fi
                        done
                      )
                    '';
                  };

                  derivedPkg = basePkg.overrideAttrs {
                    preFixup = ''
                      for index in "''${!qtWrapperArgs[@]}"; do
                        if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                          unset -v "qtWrapperArgs[$((index+0))]"
                          unset -v "qtWrapperArgs[$((index+1))]"
                          unset -v "qtWrapperArgs[$((index+2))]"
                          unset -v "qtWrapperArgs[$((index+3))]"
                        fi
                      done
                      qtWrapperArgs=("''${qtWrapperArgs[@]}")
                      qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                      qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                    '';
                  };
                in derivedPkg;
              };
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
