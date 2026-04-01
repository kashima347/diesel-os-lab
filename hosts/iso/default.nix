{ config, pkgs, lib, modulesPath, ... }:

let
  wallpaperPath = "${./../../assets/wallpapers/diesel-os-lab-wallpaper.png}";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  networking.hostName = "diesel-os-lab-iso";
  time.timeZone = "America/Sao_Paulo";

  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;

  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "nixos";

  services.upower.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    unzip
    zip
    gcc
    gnumake
    pkg-config
    python3
    jq
    file
    which
    tree
    micro
    vim
    nano
    htop
    pciutils
    usbutils
    mesa-demos
    firefox
    gnome-tweaks
    bitwarden-desktop
    onlyoffice-desktopeditors
    steam
    mangohud
    goverlay
    protonup-qt
    gparted
    parted
    gnome-console
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
    fluent-icon-theme
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  services.flatpak.enable = true;
  programs.dconf.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          icon-theme = "Fluent-dark";
          cursor-theme = "Adwaita";
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file://${wallpaperPath}";
          picture-uri-dark = "file://${wallpaperPath}";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${wallpaperPath}";
          picture-options = "zoom";
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          experimental-features = [ "scale-monitor-framebuffer" ];
        };

        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = lib.gvariant.mkInt32 1;
        };

        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "dash-to-dock@micxgx.gmail.com"
            "caffeine@patapon.info"
          ];
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Nautilus.desktop"
            "steam.desktop"
            "bitwarden.desktop"
            "onlyoffice-desktopeditors.desktop"
            "kgx.desktop"
          ];
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "BOTTOM";
          autohide = true;
          intellihide = true;
          dock-fixed = false;
          click-action = "minimize";
          scroll-action = "cycle-windows";
          dash-max-icon-size = lib.gvariant.mkInt32 40;
          background-opacity = 0.75;
          show-trash = false;
          show-mounts = false;
          isolate-workspaces = false;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };
      };
    }
  ];

  environment.etc."skel/Desktop/Instalar Diesel OS Lab.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Instalar Diesel OS Lab
    Comment=Executar o instalador gráfico
    Exec=calamares
    Icon=drive-harddisk
    Terminal=false
    Categories=System;
  '';

  environment.etc."skel/Desktop/Instalar Diesel OS Lab.desktop".mode = "0755";

  isoImage.volumeID = "DIESEL_OS_LAB";
  image.fileName = "diesel-os-lab.iso";

  system.stateVersion = "25.11";
}
