{ pkgs, ... }:
{

    imports = [
        ./plasma-generated.nix
    ];

    home.username = "belchi";
    home.homeDirectory = "/home/belchi";
    home.stateVersion = "26.05";

   home.packages = with pkgs; [
    papirus-icon-theme

    obsidian
    stable.davinci-resolve
    cider-2
    parsec-bin

    zed-editor
    proton-vpn
    proton-pass
    proton-authenticator

    audacity
    vlc
    anki
    teams-for-linux
    zapzap
    protonup-qt
    kdePackages.kdeconnect-kde
    nixd
    libreoffice-qt-fresh

    meslo-lgs-nf
    pokeget-rs

    maestral
    maestral-gui

    firefox

    calibre
    libgourou

    ffmpeg
    yt-dlp

    fishPlugins.tide
    fishPlugins.autopair
   ];

   programs.fish = {
     enable = true;
     functions = {
      fish_greeting = {
        body = ''
          set random_id (random 1 721)
            if test (random 1 100) -eq 1
              pokeget $random_id --shiny --hide-name
            else
              pokeget $random_id --hide-name
            end
         '';
      };
      toh264 = {
        body = ''
          if test (count $argv) -lt 1
            echo "Error: Please provide an input file."
            echo "Usage: optimize_video input_file.mov"
            return 1
          end

          set -l file $argv[1]
          set -l out_dir (path dirname $file)
          set -l filename (path change-extension "" (basename $file))
          set -l out_file "$out_dir/$filename.mp4"

          ffmpeg -i $file -vcodec libx264 -profile:v high -level:v 4.1 -pix_fmt yuv420p -crf 20 -acodec aac -ar 44100 $out_file
        '';
      };
      toprores = {
        body  = ''
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

  systemd.user.services.maestral = {
      Unit = {
        Description = "Maestral Dropbox Sync Daemon";
        After = [ "network-online.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "notify";
        ExecStart = "${pkgs.maestral}/bin/maestral start -f";
        ExecStop = "${pkgs.maestral}/bin/maestral stop";
        Restart = "on-failure";
        WatchdogSec = "30s";
      };
  };

  programs.plasma.panels = [
  {
      location = "bottom";
      height = 48;
  }
  ];
}
