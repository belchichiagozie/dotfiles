{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      papirus-icon-theme
      vlc
      firefox
      pokeget-rs
      fastfetch
      cider-2
      parsec-bin
      appimage-run
      git
      nixd

      proton-vpn
      proton-pass
      proton-authenticator

      fishPlugins.tide
      fishPlugins.autopair
      fishPlugins.sponge

      kdePackages.kdeconnect-kde
      zed-editor
    ];
  };

  programs = {
    fish = {
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
      };
    };

    plasma = {
      enable = true;
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        colorScheme = "BreezeDark";
        iconTheme = "Papirus-Dark";
      };

      panels = [
        {
          location = "bottom";
          height = 48;
        }
      ];

    };
  };

  services = {
    flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
