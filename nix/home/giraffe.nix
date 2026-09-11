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
      protonplus
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
          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake";
              };
            }

            {
              iconTasks = {
                launchers = [
                  "applications:firefox.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.konsole.desktop"
                  "applications:steam.desktop"
                  "applications:parsecd.desktop"
                  "applications:cider-2.desktop"
                  "applications:proton.vpn.app.gtk.desktop"
                ];
              };
            }
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
      ];
    };
  };

  services = {
    flatpak.packages = [
      "com.usebottles.bottles"
      "org.vinegarhq.Sober"
    ];
  };
}
