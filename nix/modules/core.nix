{ pkgs, ... }:
let
  rebuild = pkgs.writeShellScriptBin "rebuild" (builtins.readFile ../../bash/rebuild.sh);
in
{

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    initrd.verbose = false;
    consoleLogLevel = 0;
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
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
  };

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;
    openssh.enable = true;
    flatpak.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      xkb.layout = "gb";
    };

  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "proton0" ];
    };
  };

  console.keyMap = "uk";
  time.timeZone = "Europe/London";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager
      rebuild
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
      konversation
      ktorrent
      qrca
      kate
      discover
      kinfocenter
      kwalletmanager
    ];
  };

  programs = {
    fish.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraPkgs =
          pkgs': with pkgs'; [
            libXcursor
            libXi
            libXinerama
            libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
    };
    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = false;
    };
  };

  virtualisation.libvirtd.enable = true;
  security.rtkit.enable = true;
  nixpkgs.config.allowUnfree = true;
}
