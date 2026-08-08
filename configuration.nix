
{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.kernelParams = [
  "quiet"
  "splash"
  "vga=current"
  "rd.systemd.show_status=false"
  "rd.udev.log_level=3"
  "udev.log_priority=3"
  ];


  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  networking.hostName = "nixos-btw";

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
          General = {
              Experimental = true;
              FastConnectable = true;
          };
          Policy = {
              AutoEnable = true;
          };
      };
  };

  time.timeZone = "Turkey/Istanbul";

  # Wayland wms
  programs.hyprland.enable = true;

  services.displayManager.sddm = {
      enable = true;
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  services.xserver.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.yigit = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh.enable = true;
  users.users.yigit.shell = pkgs.zsh;

  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true; 

  environment.systemPackages = with pkgs; [
    inputs.helium.packages.${pkgs.system}.default
    gsettings-desktop-schemas
    vim
    wget
    git
    kitty
  ];

  environment.variables.GSETTINGS_SCHEMA_DIR =
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";

  services.dbus.packages = with pkgs; [ 
      gsettings-desktop-schemas 
  ];

  services.power-profiles-daemon.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Do not touch apereantly
  system.stateVersion = "26.05"; # Did you read the comment?
}
