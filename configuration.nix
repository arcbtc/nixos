{ config, pkgs, ... }:
  let
    nostrSocial = pkgs.appimageTools.wrapType2 {
      pname = "nostr-social";
      version = "latest";
      src = /home/ben/Apps/Nostr-Social.AppImage;
    };
  in
 {
  imports = [
    ./hardware-configuration.nix
    ./cachix.nix
  ];
  boot.kernelParams = [
    "existing-option"
    "nvme_core.default_ps_max_latency_us=0"
  ];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    nostrSocial
    cachix
    hicolor-icon-theme
    adwaita-icon-theme
    shared-mime-info
    desktop-file-utils
    appimage-run
    gnupg
    marp-cli
    htop
    uv
    gh
    smartmontools
    bitcoin
    rustc
    cargo
    poetry
    # python312
    gcc
    protonvpn-gui
    obs-studio
    sqlitebrowser
    # davinci-resolve
    gradle
    git
    google-chrome
    gnumake
    nodejs
    alsa-utils
    fastfetch
    vscode
    spotify
    gimp
    kdePackages.kdenlive
    telegram-desktop
    signal-desktop
    gitkraken
    jitsi-meet-electron
    firefox-gnome-theme
    flatpak
    arduino-cli
  ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };


  console.keyMap = "uk";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  virtualisation.docker.enable = true;

  services.tailscale.enable = true;
  users.users.ben = {
    isNormalUser = true;
    description = "Daedalus";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "docker"
      "dialout"
    ];
  };

  programs.firefox = {
    enable = true;

    preferences = {
      "browser.uidensity" = 1;
      "browser.compactmode.show" = true;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.tabs.tabmanager.enabled" = false;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  xdg.mime.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "application/xhtml+xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/about" = [ "firefox.desktop" ];
    "x-scheme-handler/unknown" = [ "firefox.desktop" ];
  };

  nix = {
    package = pkgs.nix;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "ben" ];
    };
  };

  services.flatpak.enable = true;

  system.stateVersion = "25.11";
}

