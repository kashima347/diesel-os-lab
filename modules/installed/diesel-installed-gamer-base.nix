{ config, pkgs, lib, dieselAssetPaths ? null, ... }:

let
  dieselPrettyName = "Diesel OS Lab — Technology & Gaming Platform";

  dieselLogo =
    if dieselAssetPaths != null && dieselAssetPaths ? logo then
      dieselAssetPaths.logo
    else
      builtins.path {
        path = ../../assets/branding/logo/diesel-os-lab-icon.png;
        name = "diesel-os-lab-icon.png";
      };

  dieselSplash =
    if dieselAssetPaths != null && dieselAssetPaths ? splash then
      dieselAssetPaths.splash
    else
      builtins.path {
        path = ../../assets/branding/splash/diesel-os-lab-splash-dark-v2-fixed.png;
        name = "diesel-os-lab-splash-dark-v2-fixed.png";
      };

  dieselAvatar =
    if dieselAssetPaths != null && dieselAssetPaths ? avatar then
      dieselAssetPaths.avatar
    else
      builtins.path {
        path = ../../assets/branding/avatar/diesel-os-lab-avatar-github-v2.png;
        name = "diesel-os-lab-avatar-github-v2.png";
      };

  dieselWallpaper =
    if dieselAssetPaths != null && dieselAssetPaths ? wallpaper then
      dieselAssetPaths.wallpaper
    else
      builtins.path {
        path = ../../assets/branding/wallpaper/diesel-os-lab-wallpaper-dark-1080p-v3.jpg;
        name = "diesel-os-lab-wallpaper-dark-1080p-v3.jpg";
      };

  dieselBrandingAssets = pkgs.runCommandLocal "diesel-os-lab-branding-assets-installed-gamer-base" { } ''
    mkdir -p $out/share/diesel-os-lab
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp ${dieselLogo} $out/share/diesel-os-lab/logo.png
    cp ${dieselSplash} $out/share/diesel-os-lab/splash.png
    cp ${dieselAvatar} $out/share/diesel-os-lab/avatar.png
    cp ${dieselWallpaper} $out/share/diesel-os-lab/wallpaper.png

    cp ${dieselLogo} $out/share/icons/hicolor/512x512/apps/diesel-os-lab.png
  '';
in
{
  boot.plymouth = {
    enable = true;
    theme = "spinner";
    logo = dieselLogo;
  };

  system.nixos.distroName = "Diesel OS Lab";
  system.nixos.vendorName = "Diesel OS Lab";
  system.nixos.extraOSReleaseArgs = {
    PRETTY_NAME = "Diesel OS Lab - Technology and Gaming Platform";
    FANCY_NAME = dieselPrettyName;
    DEFAULT_HOSTNAME = "diesel-os-lab";
    LOGO = "diesel-os-lab";
  };

  programs.dconf.enable = true;

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
  };

  networking.hostName = lib.mkDefault "diesel-os-lab";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-software.enable = true;

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  services.fstrim.enable = true;
  services.ratbagd.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          cursor-theme = "Adwaita";
          icon-theme = "Fluent-dark";
          enable-animations = false;
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file://${dieselBrandingAssets}/share/diesel-os-lab/wallpaper.png";
          picture-uri-dark = "file://${dieselBrandingAssets}/share/diesel-os-lab/wallpaper.png";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${dieselBrandingAssets}/share/diesel-os-lab/wallpaper.png";
          picture-options = "zoom";
        };

        "org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
          dynamic-workspaces = false;
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = ":minimize,maximize,close";
          num-workspaces = lib.gvariant.mkInt32 1;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };

        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "dash-to-dock@micxgx.gmail.com"
            "caffeine@patapon.info"
          ];
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Calendar.desktop"
            "org.gnome.Nautilus.desktop"
            "org.gnome.Console.desktop"
            "steam.desktop"
          ];
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          animation-time = lib.gvariant.mkDouble 0.15;
          autohide = true;
          autohide-in-fullscreen = true;
          background-opacity = lib.gvariant.mkDouble 0.75;
          click-action = "minimize";
          dash-max-icon-size = lib.gvariant.mkInt32 40;
          disable-overview-on-startup = true;
          dock-fixed = false;
          dock-position = "BOTTOM";
          extend-height = false;
          hide-delay = lib.gvariant.mkDouble 0.05;
          intellihide = true;
          isolate-workspaces = false;
          pressure-threshold = lib.gvariant.mkDouble 0.0;
          require-pressure-to-show = false;
          scroll-action = "cycle-windows";
          show-delay = lib.gvariant.mkDouble 0.05;
          show-mounts = false;
          show-trash = false;
          transparency-mode = "FIXED";
        };
      };
    }
  ];

  environment.etc."diesel-os-lab/default-avatar.png".source =
    "${dieselBrandingAssets}/share/diesel-os-lab/avatar.png";

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    nano
    micro
    htop
    pciutils
    usbutils
    mesa-demos

    gnome-tweaks
    gnome-software

    bitwarden-desktop
    onlyoffice-desktopeditors
    warehouse

    mangohud
    goverlay
    protonup-qt
    protonplus

    fluent-icon-theme
    dieselBrandingAssets

    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine

    piper
  ];

  programs.firefox.enable = true;

  services.flatpak.enable = true;

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.11";
}
