
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
    configurationLimit = 10;
    efiInstallAsRemovable = true;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelParams = [
  "quiet"
  "splash"
  "loglevel=3"
  "rd.systemd.show_status=false"
  "rd.udev.log_level=3"
  "udev.log_priority=3"
  ];


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
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

  services.blueman.enable = true;

  time.timeZone = "Europe/Istanbul";

  # Wayland wms
  programs.hyprland = {
    enable = true;
  };

  programs.steam.enable = true;

  # X11 is what the X server needs to exist for sddm's X11 greeter. It does not
  # pull in a desktop, and hyprland still runs as a native wayland session.
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = false;
  };

  services.displayManager.defaultSession = "hyprland";

  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

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
    inputs.helium.packages.${pkgs.hostPlatform.system}.default
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

  fonts.enableDefaultPackages = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Do not touch apereantly
  system.stateVersion = "26.05"; # Did you read the comment?
}
