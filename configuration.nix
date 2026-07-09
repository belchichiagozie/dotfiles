{ pkgs, ... }:

let
  WallpaperOverride = pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    background=${./Wallpapers/traveller.jpg}
    type=image
  '';

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
      set -e
      cd ~/dotfiles/

      if git diff --quiet HEAD; then
          echo "No changes detected. Skipping rebuild."
          exit 0
      fi

      echo "Rebuilding NixOS..."
      sudo nixos-rebuild switch --flake .#SNAIL

      current_gen=$(nixos-rebuild list-generations | grep 'True$' | awk '{print $1, $2, $3}')

      git add .
      git commit -m "NixOS Rebuild: $current_gen"
      echo "Done!"
    '';
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    loader.timeout = 1;

    kernelPackages = pkgs.linuxPackages_latest;

    plymouth.enable = true;
    plymouth.theme = "mac-style";
    plymouth.themePackages = [ pkgs.mac-style-plymouth ];
    kernelParams = [ "quiet" "splash" "boot.shell_on_fail" "fastboot" "noresume" ];

    initrd.verbose = false;
    consoleLogLevel = 0;
  };

  systemd.targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

  networking.hostName = "SNAIL";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."belchi" = {
    isNormalUser = true;
    description = "Belchi Emeka-Gwacham";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.steam = {
    enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      git
      fastfetch
      curl
      wget
      nix-search-cli
      comma
      appimage-run
      nix-index
      home-manager
      WallpaperOverride
      rebuild
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa khelpcenter konversation ktorrent qrca kate discover kinfocenter kwalletmanager
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  hardware.amdgpu.opencl.enable = true;

  services.openssh.enable = true;

  system.stateVersion = "26.05";
}
