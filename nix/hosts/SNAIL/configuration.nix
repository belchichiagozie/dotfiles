{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../../modules/sddm-wallpaper.nix ../../../wallpapers/traveller.jpg)
  ];

  systemd.targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
  };

  networking.hostName = "SNAIL";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
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
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };

  system.stateVersion = "26.05";
}
