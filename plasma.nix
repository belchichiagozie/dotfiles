{
    programs.plasma.panels = [
    {
        location = "bottom";
        height = 48;
    }
    ];

    programs.plasma.configFiles = {
      kscreenlockerrc = {
        "Greeter/Wallpaper/org.kde.image/General" = {
          Image = "file://${./Wallpapers/traveller.jpg}";
          PreviewImage = "file://${./Wallpapers/traveller.jpg}";
        };
      };
    };

}
