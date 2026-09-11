{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ../../modules/sddm-wallpaper.nix ../../../wallpapers/alita-battle-angel-uhdpaper.com-4K-29.jpg)
  ];

  networking.hostName = "GIRAFFE";

  users.users.belchi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "gamemode"
    ];
    description = "Belchi";
    initialPassword = "changeme";
    shell = pkgs.fish;
  };

  fileSystems = {
    "/mnt/ssd1" = {
      device = "/dev/disk/by-uuid/9cd5db9f-1a36-43bd-ae5e-6052cd1c8064";
      fsType = "btrfs";
      options = [
        "defaults"
        "nofail"
      ];
    };

    "/mnt/hdd1" = {
      device = "/dev/disk/by-uuid/1baa03aa-772b-4b6e-8440-fbd05891dc2b";
      fsType = "btrfs";
      options = [
        "defaults"
        "nofail"
      ];
    };
  };

  system.stateVersion = "26.05";
}
