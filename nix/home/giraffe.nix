{ pkgs, ... }:
{
  home = {
    username = "belchi";
    homeDirectory = "/home/belchi";
    stateVersion = "26.05";

    packages = with pkgs; [
      lutris
      heroic
      prismlauncher
      protonup-qt
      qbittorrent
      mangohud
      zed-editor
    ];
  };

  programs = {
    plasma = {
      workspace.wallpaper = ../../../wallpapers/gia-nguyen-3.jpg;
      panels = [
        {
          location = "bottom";
          height = 48;
        }
      ];
    };
  };

  services = {
    flatpak.packages = [ "com.usebottles.bottles" ];
  };
}
