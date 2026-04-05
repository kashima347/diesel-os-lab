{ config, lib, pkgs, modulesPath, ... }:

let
  dieselLogo = ../assets/branding/logo/diesel-os-lab-icon.png;
  dieselSplash = ../assets/branding/splash/diesel-os-lab-splash-dark-v2-fixed.png;
  dieselAvatar = ../assets/branding/avatar/diesel-os-lab-avatar-github-v2.png;
  dieselWallpaper = ../assets/branding/wallpaper/diesel-os-lab-wallpaper-dark-1080p-v3.jpg;

  dieselInstalledModule = ../modules/installed/diesel-installed-gamer-base.nix;

  dieselInstallerArgsModule = pkgs.writeText "diesel-installed-gamer-base-asset-args.nix" ''
    { ... }:

    {
      _module.args.dieselAssetPaths = {
        logo = ${dieselLogo};
        splash = ${dieselSplash};
        avatar = ${dieselAvatar};
        wallpaper = ${dieselWallpaper};
      };
    }
  '';

  dieselBrandingAssets = pkgs.runCommandLocal "diesel-os-lab-branding-assets-iso" { } ''
    mkdir -p $out/share/diesel-os-lab
    mkdir -p $out/share/icons/hicolor/512x512/apps

    cp ${dieselLogo} $out/share/diesel-os-lab/logo.png
    cp ${dieselSplash} $out/share/diesel-os-lab/splash.png
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
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
    ../modules/shared/diesel-defaults.nix
    ../modules/profiles/kernel-zen.nix
  ];

  networking.hostName = "diesel-os-lab-iso";
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

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];

  hardware.enableRedistributableFirmware = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "nixos";

  services.upower.enable = true;
  security.polkit.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      calamares-nixos-extensions = prev.calamares-nixos-extensions.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          mkdir -p $out/share/calamares/branding/diesel-os-lab
          cp -r $out/share/calamares/branding/nixos/. $out/share/calamares/branding/diesel-os-lab/

          cp ${dieselLogo} $out/share/calamares/branding/diesel-os-lab/diesel-os-lab-icon.png
          cp ${dieselSplash} $out/share/calamares/branding/diesel-os-lab/diesel-os-lab-splash.png

          cat > $out/share/calamares/branding/diesel-os-lab/show.qml <<'EOF'
import QtQuick 2.15

Rectangle {
  width: 800
  height: 520
  color: "#111418"

  function onActivate() {}
  function onLeave() {}

  Rectangle {
    anchors.fill: parent
    color: "#0F141A"
  }

  Column {
    anchors.centerIn: parent
    width: 640
    spacing: 18

    Image {
      source: "diesel-os-lab-icon.png"
      width: 132
      height: 132
      fillMode: Image.PreserveAspectFit
      anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
      width: parent.width
      text: "Diesel OS Lab"
      color: "#F5F7FA"
      font.pixelSize: 30
      font.bold: true
      horizontalAlignment: Text.AlignHCenter
    }

    Text {
      width: parent.width
      text: "Technology & Gaming Platform"
      color: "#9DB4D0"
      font.pixelSize: 17
      horizontalAlignment: Text.AlignHCenter
    }

    Text {
      width: parent.width
      text: "Instalando um sistema baseado em NixOS com foco em performance, refinamento visual e experiência gamer."
      color: "#D8E1EB"
      font.pixelSize: 15
      wrapMode: Text.WordWrap
      horizontalAlignment: Text.AlignHCenter
    }

    Text {
      width: parent.width
      text: "Por volta de 46%, a instalação pode parecer mais lenta do que o normal. Isso acontece porque o sistema está realizando configurações e otimizações essenciais para garantir uma experiência mais estável, refinada e completa. Aguarde com tranquilidade — o processo segue normalmente."
      color: "#BFD1E6"
      font.pixelSize: 13
      wrapMode: Text.WordWrap
      horizontalAlignment: Text.AlignHCenter
    }
  }
}
EOF

          cat > $out/share/calamares/branding/diesel-os-lab/branding.desc <<'EOF'
# SPDX-FileCopyrightText: no
# SPDX-License-Identifier: CC0-1.0
---
componentName: diesel-os-lab

welcomeStyleCalamares: false
welcomeExpandingLogo: true

windowExpanding: normal
windowSize: 800px,520px
windowPlacement: center

sidebar: widget
navigation: widget

strings:
    productName:         "Diesel OS Lab"
    shortProductName:    "Diesel OS Lab"
    version:
    shortVersion:
    versionedName:       "Diesel OS Lab"
    shortVersionedName:  "Diesel OS Lab"
    bootloaderEntryName: "Diesel OS Lab"
    productUrl:          "https://github.com/kashima347/diesel-os-lab"
    supportUrl:          "https://github.com/kashima347/diesel-os-lab/tree/main/docs/support"
    knownIssuesUrl:      "https://github.com/kashima347/diesel-os-lab/issues"
    releaseNotesUrl:     "https://github.com/kashima347/diesel-os-lab"
    donateUrl:           "https://github.com/sponsors/kashima347"

images:
    productIcon:         "diesel-os-lab-icon.png"
    productLogo:         "diesel-os-lab-icon.png"
    productWelcome:      "diesel-os-lab-splash.png"

style:
   SidebarBackground:        "#0F141A"
   SidebarText:              "#F5F7FA"
   SidebarTextCurrent:       "#0F141A"
   SidebarBackgroundCurrent: "#7FAAD9"

slideshow: "show.qml"
slideshowAPI: 1

uploadServer:
    type: "fiche"
    url: "http://termbin.com:9999"
    sizeLimit: -1
EOF

          ${final.python3}/bin/python3 <<EOF
from pathlib import Path

main_py = Path("$out/lib/calamares/modules/nixos/main.py")
text = main_py.read_text()
text = text.replace(
    "      ./hardware-configuration.nix\\n    ];\\n",
    "      ./hardware-configuration.nix\\n      ${dieselInstallerArgsModule}\\n      ${dieselInstalledModule}\\n    ];\\n"
)
main_py.write_text(text)

settings_conf = Path("$out/etc/calamares/settings.conf")
text = settings_conf.read_text()
text = text.replace("branding: nixos", "branding: diesel-os-lab")
settings_conf.write_text(text)
EOF
        '';
      });
    })
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

  environment.etc."skel/Desktop/Instalar Diesel OS Lab.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Instalar Diesel OS Lab
    Comment=Executar o instalador gráfico
    Exec=calamares
    Icon=${dieselBrandingAssets}/share/icons/hicolor/512x512/apps/diesel-os-lab.png
    Terminal=false
    Categories=System;
  '';

  environment.etc."skel/Desktop/Instalar Diesel OS Lab.desktop".mode = "0755";

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

    gnome-software

    bitwarden-desktop
    onlyoffice-desktopeditors
    rustdesk
    warehouse

    mangohud
    goverlay
    protonup-qt
    protonplus

    piper
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  services.flatpak.enable = true;
  services.ratbagd.enable = true;
  services.fstrim.enable = true;

  users.users.nixos.extraGroups = [ "networkmanager" "wheel" ];

  isoImage.volumeID = "DIESEL_OS_LAB";
  image.fileName = "diesel-os-lab-2026-04-04.iso";

  system.stateVersion = "25.11";
}
