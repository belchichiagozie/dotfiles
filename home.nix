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
   ];

   programs.fish = {
     enable = true;
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
