{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    panels = [{
      location = "bottom";
      height = 48;

      widgets = [
        { kickoff = { icon = "nix-snowflake-white"; }; }
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
              "applications:org.kde.plasma.systemmonitor.desktop"
              "applications:anki.desktop"
              "applications:teams-for-linux.desktop"
            ];
          };
        }

        "org.kde.plasma.systemtray"
        "org.kde.plasma.digitalclock"
      ];
    }];
  };
}
