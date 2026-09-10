{ pkgs, ... }:

let
  WallpaperOverride = pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    [General]
    background=${../wallpapers/traveller.jpg}
    type=image
  '';
  rebuild = pkgs.writeShellScriptBin "rebuild" (builtins.readFile ../bash/rebuild.sh);
in
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    plymouth.enable = true;
    kernelParams = [ "quiet" "splash" "boot.shell_on_fail" "fastboot" "noresume" ];
    initrd.verbose = false;
    consoleLogLevel = 0;
  };

  systemd.targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
  };

  services = {
    printing.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;

    # Sound
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Display
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

  networking = {
    hostName = "SNAIL";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "proton0" ];
    };
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs = {
    fish.enable = true;
    steam.enable = true;
    gamemode.enable = true;
  };

  users.users."belchi" = {
    isNormalUser = true;
    description = "Belchi Emeka-Gwacham";
    extraGroups = [ "networkmanager" "wheel" "libvirtd"];
    shell = pkgs.fish;
  };

  hardware = {
    amdgpu.opencl.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };

  environment = {
    systemPackages = with pkgs; [ home-manager WallpaperOverride rebuild ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa khelpcenter konversation ktorrent qrca kate discover kinfocenter kwalletmanager
    ];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  console.keyMap = "uk";
  time.timeZone = "Europe/London";
  virtualisation.libvirtd.enable = true;
  security.rtkit.enable = true;
  system.stateVersion = "26.05";
}
