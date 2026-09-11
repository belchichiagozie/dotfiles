wallpaperPath: { pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${wallpaperPath}
      type=image
    '')
  ];
}
