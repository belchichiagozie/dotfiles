{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users."belchi" = {
    isNormalUser = true;
    description = "Belchi Emeka-Gwacham";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa khelpcenter konversation ktorrent qrca kate
  ];

  programs.firefox.enable = true;
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      git
      fastfetch
      mesa
      libgbm
      curl
      wget
      nix-search-cli
      comma
      appimage-run
  ];

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  hardware.amdgpu.opencl.enable = true;

  services.openssh.enable = true;

  system.stateVersion = "26.05";

}
