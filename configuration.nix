
{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.silentSDDM.nixosModules.default
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 10;
    efiInstallAsRemovable = true;
    splashImage = null;
    theme = null;
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

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  networking.hostName = "nixos-btw";

  networking.networkmanager.enable = true;

  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  documentation.man.man-db.enable = true;

  systemd.services.spoofdpi = {
  description = "SpoofDPI Service";
  wantedBy = [ "multi-user.target" ];
  wants = [ "network-online.target" ];
  after = [ "network-online.target" ];

  serviceConfig = {
    # Assuming spoofdpi is available in pkgs
      ExecStart = "${pkgs.spoofdpi}/bin/spoofdpi --dns-mode https --https-split-mode chunk --https-chunk-size 1 --https-fake-count 5 --listen-addr 127.0.0.1:9090";
      Restart = "always";
      RestartSec = "5";

    # Run securely with only the specific network capability needed
      DynamicUser = true;
      AmbientCapabilities = [ "CAP_NET_RAW" ];
      CapabilityBoundingSet = [ "CAP_NET_RAW" ];
      };
  };

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
  programs.hyprland.enable = true;
  programs.mango.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.steam.enable = true;
  services.upower.enable = true;
  programs.gamemode.enable = true;

  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = false;
  };

  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds.my_wallpaper = ./wallpapers/mandelbrot_full_blue.png;
    settings.LoginScreen.background = "mandelbrot_full_blue.png";
    settings.LockScreen.background = "mandelbrot_full_blue.png";
  };

  services.displayManager.defaultSession = "hyprland";

  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Required for yabridge/wine VST bridging
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    
    # Global low-latency defaults
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;       # Fixed rate avoids resampling latency
        "default.clock.quantum" = 128;      # ~5ms latency at 48kHz
        "default.clock.min-quantum" = 32;   # Allows top-tier interfaces to achieve ~1.5ms
        "default.clock.max-quantum" = 512;
      };
    };

    # Disable node suspension and fix crackling on problematic USB interfaces
    wireplumber.extraConfig."99-disable-suspend" = {
      "monitor.alsa.rules" = [{
        matches = [
          { "node.name" = "~alsa_input.*"; }
          { "node.name" = "~alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
            # Optional: Tweak by trial-and-error if crackling occurs on specific USB interfaces.
            # Do not apply globally without testing, as it may break built-in audio.
            # "api.alsa.period-size" = 2;
            # "api.alsa.headroom" = 8192;
          };
        };
      }];
    };
  };

  environment.variables = let
	  makePluginPath = format:
	  (pkgs.lib.makeSearchPath format [
	   "$HOME/.nix-profile/lib"
	   "/run/current-system/sw/lib"
	   "/etc/profiles/per-user/yigit/lib"
	  ]) + ":/home/yigit/.${format}";
  in {
	  LV2_PATH = makePluginPath "lv2";
	  VST3_PATH = makePluginPath "vst3";
	  CLAP_PATH = makePluginPath "clap";
  };


  security.rtkit.enable = true;

  security.pam.loginLimits = [
  { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
  { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  { domain = "@audio"; item = "nice"; type = "-"; value = "-19"; }
  ];


  users.users.yigit = {
	  isNormalUser = true;
	  extraGroups = [ "wheel" "networkmanager" "audio"]; # Enable ‘sudo’ for the user.
		  packages = with pkgs; [
		  tree
		  ];
  };

  programs.zsh.enable = true;
  users.users.yigit.shell = pkgs.zsh;

  programs.dconf.enable = true;

  nixpkgs.config.allowUnfree = true; 

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
	  gxplugins-lv2
		  neural-amp-modeler-lv2
		  dragonfly-reverb
		  jdk21
		  man-pages
		  man-pages-posix
		  llvmPackages_latest.libllvm
		  llvmPackages_latest.libcxx
		  llvmPackages_latest.clang
		  clang-tools 
		  clang
		  xsettingsd
		  xrdb
		  nodejs
		  postgrest
		  inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
		  gsettings-desktop-schemas
		  vim
		  wget
		  git
		  kitty
  ];

  environment.sessionVariables.GSETTINGS_SCHEMA_DIR =
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
