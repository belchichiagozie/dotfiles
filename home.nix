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
        maestral
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
        fish
   ];

   home.sessionVariables = {
    RUSTICL_ENABLE = "radeonsi";
  };


    programs.plasma.panels = [
    {
        location = "bottom";
        height = 48;
    }
    ];

}
