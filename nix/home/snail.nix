{ pkgs, ... }:
{
  home = {
    username = "belchi";
    homeDirectory = "/home/belchi";
    stateVersion = "26.05";

    packages = with pkgs; [
      obsidian
      stable.davinci-resolve
      lutris
      zed-editor
      texliveFull
      audacity
      anki
      teams-for-linux
      zapzap
      protonup-qt
      kdePackages.kdeconnect-kde
      nixd
      libreoffice-qt-fresh
      meslo-lgs-nf
      maestral
      maestral-gui
      calibre
      libgourou
      ffmpeg
      yt-dlp
      virt-manager
    ];
  };

  programs = {

    plasma = {
      workspace.wallpaper = ./../../wallpapers/traveller.jpg;
      panels = [
        {
          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake-white";
              };
            }

            {
              iconTasks = {
                launchers = [
                  "applications:firefox.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.konsole.desktop"
                  "applications:com.rtosta.zapzap.desktop"
                  "applications:obsidian.desktop"
                  "applications:dev.zed.Zed.desktop"
                  "applications:cider-2.desktop"
                  "applications:parsecd.desktop"
                  "applications:steam.desktop"
                  "applications:proton.vpn.app.gtk.desktop"
                  "applications:proton-pass.desktop"
                  "applications:davinci-resolve.desktop"
                  "applications:teams-for-linux.desktop"
                ];
              };
            }
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
    };

    fish = {
      functions = {
        toh264 = {
          body = ''
            if test (count $argv) -lt 1
              echo "Error: Please provide an input file."
              echo "Usage: optimize_video input_file.mov"
              return 1
            end

            set -l file $argv[1]
            set -l filename (path change-extension "" (basename $file))
            set -l out_file "$filename.mp4"

            ffmpeg -i $file -vcodec libx264 -profile:v high -level:v 4.1 -pix_fmt yuv420p -crf 20 -acodec aac -ar 44100 $out_file
          '';
        };
        toprores = {
          body = ''
            if test (count $argv) -lt 1
              echo "Error: Please provide an input file."
              echo "Usage: optimize_video input_file.mp4"
              return 1
            end

            set -l file $argv[1]
            set -l out_dir (path dirname $file)
            set -l filename (path change-extension "" (basename $file))
            set -l out_file "$filename.mov"

            ffmpeg -i $file -vcodec prores -profile:v 1 -acodec pcm_s16le -threads 0 $out_file
          '';
        };
      };
    };
  };

  services = {
    flatpak = {
      packages = [ "com.usebottles.bottles" ];
    };
  };

  systemd.user.services = {
    maestral = {
      Unit = {
        Description = "Maestral Dropbox Sync Client";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.maestral}/bin/maestral start -f";
        ExecStop = "${pkgs.maestral}/bin/maestral stop";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
