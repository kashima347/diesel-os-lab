{ config, pkgs, lib, ... }:

let
  dieselPrettyName = "Diesel OS Lab — Technology & Gaming Platform";
  dieselLogo = /home/hal/diesel-os-lab/assets/branding/logo/diesel-os-lab-icon.png;
  dieselSplash = /home/hal/diesel-os-lab/assets/branding/splash/diesel-os-lab-splash-dark-v2-fixed.png;
  dieselAvatar = /home/hal/diesel-os-lab/assets/branding/avatar/diesel-os-lab-avatar-github-v2.png;
  dieselWallpaper = /home/hal/diesel-os-lab/assets/branding/wallpaper/diesel-os-lab-wallpaper-dark-1080p-v3.jpg;
  dieselDconfBackup = /home/hal/diesel-os-lab/nixos-machines/hal/dconf-backup.ini;

  unstablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/71caefc.tar.gz";
  }) {
    localSystem = pkgs.stdenv.hostPlatform;
    config.allowUnfree = true;
  };

  dieselBrandingAssets = pkgs.runCommandLocal "diesel-os-lab-branding-assets" { } ''
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
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  boot.plymouth = {
    enable = true;
    theme = "spinner";
    logo = dieselLogo;
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.kernelPackages = unstablePkgs.linuxPackages_zen;

  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
    "nvidia-drm.modeset=1"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
  };

  fileSystems."/mnt/vmstore" = {
    device = "/dev/disk/by-uuid/7f51b176-a0d1-4213-80c4-0f58b957315e";
    fsType = "xfs";
    options = [ "nofail" "x-gvfs-show" ];
  };

  networking.hostName = "diesel-os-lab";
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

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.58.03";
      sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
      sha256_aarch64 = "sha256-hzzIKY1Te8QkCBWR+H5k1FB/HK1UgGhai6cl3wEaPT8=";
      openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8=";
      settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
      persistencedSha256 = "sha256-AtjM/ml/ngZil8DMYNH+P111ohuk9mWw5t4z7CHjPWw=";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "deftdawg";
          repo = "libfprint-CS9711";
          rev = "56bf490f8ea2ab9049f410b9dfe78b33d59fd2c4";
          sha256 = "sha256-PVr/Mi3m0P1bojVYriubmpA8QC5oayV5RtHbyXyHPC0=";
        };
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
          final.opencv
          final.cmake
          final.doctest
        ];
      });
    })
  ];

  system.nixos.distroName = "Diesel OS Lab";
  system.nixos.vendorName = "Diesel OS Lab";
  system.nixos.extraOSReleaseArgs = {
    PRETTY_NAME = "Diesel OS Lab - Technology and Gaming Platform";
    FANCY_NAME = dieselPrettyName;
    DEFAULT_HOSTNAME = "diesel-os-lab";
    LOGO = "diesel-os-lab";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  services.fstrim.enable = true;
  services.fprintd.enable = true;
  services.ratbagd.enable = true;
  services.lact.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  users.users.hal = {
    isNormalUser = true;
    description = "hal";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" ];
  };

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

        "org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
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

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
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
            "org.gnome.Software.desktop"
            "org.gnome.Console.desktop"
          ];
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "BOTTOM";
          extend-height = false;
          dock-fixed = false;
          autohide = true;
          autohide-in-fullscreen = true;
          intellihide = true;
          disable-overview-on-startup = true;
          require-pressure-to-show = false;
          pressure-threshold = lib.gvariant.mkDouble 0.0;
          show-trash = false;
          show-mounts = false;
          isolate-workspaces = false;
          click-action = "minimize";
          scroll-action = "cycle-windows";
          show-delay = lib.gvariant.mkDouble 0.0;
          hide-delay = lib.gvariant.mkDouble 0.0;
          animation-time = lib.gvariant.mkDouble 0.15;
          dash-max-icon-size = lib.gvariant.mkInt32 40;
          transparency-mode = "FIXED";
          background-opacity = lib.gvariant.mkDouble 0.75;
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = ":minimize,maximize,close";
        };
      };
    }
  ];

  system.activationScripts.dieselHalAvatar = ''
    mkdir -p /var/lib/AccountsService/icons
    mkdir -p /var/lib/AccountsService/users

    cp ${dieselBrandingAssets}/share/diesel-os-lab/avatar.png /var/lib/AccountsService/icons/hal

    cat > /var/lib/AccountsService/users/hal <<EOF
[User]
Icon=/var/lib/AccountsService/icons/hal
SystemAccount=false
EOF

    chmod 644 /var/lib/AccountsService/icons/hal
    chmod 644 /var/lib/AccountsService/users/hal
  '';

  systemd.user.services.diesel-dconf-restore = {
    description = "Diesel OS Lab first login dconf restore";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" ];
    path = [ pkgs.dconf pkgs.coreutils pkgs.bash ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      stamp="$HOME/.local/state/diesel-os-lab/dconf-restored"

      if [ -e "$stamp" ]; then
        exit 0
      fi

      mkdir -p "$(dirname "$stamp")"
      dconf load / < ${dieselDconfBackup}
      touch "$stamp"
    '';
  };

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

    fluent-icon-theme
    dieselBrandingAssets

    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine

    piper
    fprintd
    virt-viewer
    lact
  ];

  programs.firefox.enable = true;

  services.flatpak.enable = true;

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.11";
}
