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
    davinci-resolve
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
       fish_prompt = {
         body = ''
           set -l nix_shell_info (
             if test -n "$IN_NIX_SHELL"
               echo -n "<nix-shell> "
             end
           )
           echo -n -s "$nix_shell_info ~>"
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
