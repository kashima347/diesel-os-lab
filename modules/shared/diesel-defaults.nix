{ config, pkgs, lib, ... }:

let
  dieselPrettyName = "Diesel OS Lab — Technology & Gaming Platform";
  dieselLogo = ../../assets/branding/logo/diesel-os-lab-icon.png;
  dieselSplash = ../../assets/branding/splash/diesel-os-lab-splash-dark-v2-fixed.png;
  dieselAvatar = ../../assets/branding/avatar/diesel-os-lab-avatar-github-v2.png;
  dieselWallpaper = ../../assets/branding/wallpaper/diesel-os-lab-wallpaper-dark-1080p-v3.jpg;

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

  environment.systemPackages = with pkgs; [
    fluent-icon-theme
    dieselBrandingAssets
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.caffeine
  ];

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
      };
    }
  ];

  environment.etc."diesel-os-lab/default-avatar.png".source =
    "${dieselBrandingAssets}/share/diesel-os-lab/avatar.png";
}
