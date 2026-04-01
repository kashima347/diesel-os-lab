{ config, lib, pkgs, modulesPath, ... }:

let
  dieselPrettyName = "Diesel OS Lab — Technology & Gaming Platform";
  dieselLogo = ../assets/branding/logo/diesel-os-lab-icon.png;
  dieselAvatar = ../assets/branding/avatar/diesel-os-lab-avatar-github-v2.png;
  dieselWallpaper = ../assets/branding/wallpaper/diesel-os-lab-wallpaper-dark-4k-v3.png;

  dieselBrandingAssets = pkgs.runCommandLocal "diesel-os-lab-branding-assets" { } ''
    mkdir -p $out/share/diesel-os-lab
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp ${dieselLogo} $out/share/diesel-os-lab/logo.png
    cp ${dieselAvatar} $out/share/diesel-os-lab/avatar.png
    cp ${dieselWallpaper} $out/share/diesel-os-lab/wallpaper.png

    cp ${dieselLogo} $out/share/icons/hicolor/512x512/apps/diesel-os-lab.png
  '';

  dieselLiveSetup = pkgs.writeShellScript "diesel-live-setup" ''
    sleep 5
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme 'Fluent-dark' || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background picture-uri "file://${dieselBrandingAssets}/share/diesel-os-lab/wallpaper.png" || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background picture-uri-dark "file://${dieselBrandingAssets}/share/diesel-os-lab/wallpaper.png" || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background picture-options 'zoom' || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.screensaver picture-uri "file://${dieselBrandingAssets}/share/diesel-os-lab/wallpaper.png" || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.screensaver picture-options 'zoom' || true
  '';

  dieselInstallerAutostart = pkgs.writeShellScript "diesel-live-launch-installer" ''
    sleep 8
    if ! ${pkgs.procps}/bin/pgrep -x calamares >/dev/null 2>&1; then
      calamares >/dev/null 2>&1 &
    fi
  '';
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
  ];

  networking.hostName = "diesel-os-lab-installer";
  networking.networkmanager.enable = true;

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

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.plymouth = {
    enable = true;
    theme = "spinner";
    logo = dieselLogo;
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
    "nvidia-drm.modeset=1"
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  programs.dconf.enable = true;

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
      };
    }
  ];

  system.activationScripts.dieselLiveAvatar = ''
    mkdir -p /var/lib/AccountsService/icons
    mkdir -p /var/lib/AccountsService/users

    cp ${dieselBrandingAssets}/share/diesel-os-lab/avatar.png /var/lib/AccountsService/icons/nixos

    cat > /var/lib/AccountsService/users/nixos <<EOF
[User]
Icon=/var/lib/AccountsService/icons/nixos
SystemAccount=false
EOF

    chmod 644 /var/lib/AccountsService/icons/nixos
    chmod 644 /var/lib/AccountsService/users/nixos
  '';

  environment.etc."xdg/autostart/diesel-os-lab-live-branding.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Diesel OS Lab Live Branding
    Exec=${dieselLiveSetup}
    Terminal=false
    NoDisplay=true
    X-GNOME-Autostart-enabled=true
  '';

  environment.etc."xdg/autostart/diesel-os-lab-installer.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Diesel OS Lab Installer
    Exec=${dieselInstallerAutostart}
    Terminal=false
    NoDisplay=true
    X-GNOME-Autostart-enabled=true
  '';

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
    rustdesk
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
    fprintd
  ];

  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  services.flatpak.enable = true;
  services.fprintd.enable = true;
  services.ratbagd.enable = true;
  services.fstrim.enable = true;

  users.users.nixos.extraGroups = [ "networkmanager" "wheel" ];

  image.fileName = "diesel-os-lab-installer.iso";

  system.stateVersion = "25.11";
}
