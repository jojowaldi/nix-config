{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.custom-nixpkgs.noctalia-legacy.homeModules.default
  ];

  xdg.configFile."noctalia/colorschemes/GitHub Dark/GitHub Dark.json".source =
    ../../../assets/shells/github-dark-noctalia.json;

  home.packages = with pkgs; [
    hyprshot
    #inputs.hypr-quick-frame.packages.${stdenv.hostPlatform.system}.default.overrideAttrs
    adw-gtk3
    nwg-look
    glib
    kdePackages.qt6ct
    libsForQt5.qt5ct

    # plugins dependencies
    wl-mirror
    grim
    slurp
    wl-clipboard
    tesseract
    imagemagick
    zbar
    curl
    translate-shell
    wl-screenrec
    gifski
  ];

  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "adw-gtk3";
      package = lib.mkForce pkgs.adw-gtk3;
    };
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    GTK_THEME = "adw-gtk3";
    HYPRSHOT_DIR = "$HOME/Pictures/Screenshots";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3";
      color-scheme = "prefer-dark";
    };
  };

  services.hyprpolkitagent.enable = lib.mkForce false;
  services.kdeconnect.enable = true;

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../../assets/hyprland/noctalia-legacy.lua;

  programs.noctalia-shell = {
    enable = true;
    package = pkgs.noctalia-shell;

    colors = {
      mError = "#f85149";
      mHover = "#21262d";
      mOnError = "#010409";
      mOnHover = "#c9d1d9";
      mOnPrimary = "#010409";
      mOnSecondary = "#010409";
      mOnSurface = "#c9d1d9";
      mOnSurfaceVariant = "#8b949e";
      mOnTertiary = "#010409";
      mOutline = "#30363d";
      mPrimary = "#58a6ff";
      mSecondary = "#bc8cff";
      mShadow = "#010409";
      mSurface = "#010409";
      mSurfaceVariant = "#161b22";
      mTertiary = "#bc8cff";
    };

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        kde-connect = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        polkit-agent = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        assistant-panel = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screen-toolkit = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        mirror-mirror = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };

    pluginSettings = {
      tailscale = {
        refreshInterval = 5000;
        compactMode = true;
        showIpAddress = false;
        showPeerCount = false;
        hideDisconnected = false;
        terminalCommand = "alacritty";
        pingCount = 5;
        defaultPeerAction = "copy-ip";
      };
      screen-recorder = {
        hideInactive = true;
        iconColor = "none";
        directory = "";
        filenamePattern = "recording_yyyyMMdd_HHmmss";
        frameRate = "60";
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        copyToClipboard = false;
        audioSource = "default_output";
        videoSource = "portal";
        resolution = "original";
      };
      privacy-indicator = {
        hideInactive = true;
        iconSpacing = 4;
        removeMargins = false;
        activeColor = "primary";
        inactiveColor = "none";
      };
      assistant-panel = {
        ai = {
          provider = "openai_compatible";
          models = {
            openai_compatible = "gemma4:latest";
          };
          apiKeys = {
            openai_compatible = "";
          };
          temperature = 0.7;
          systemPrompt = "You are a helpful assistant integrated into a Linux desktop shell. Be concise and helpful.";
          openaiLocal = true;
          openaiBaseUrl = "http://192.168.178.22:11434/v1/chat/completions";
          model = "gemma4:latest";
        };
        translator = {
          backend = "google";
          deeplApiKey = "";
          realTimeTranslation = true;
        };
        maxHistoryLength = 100;
        panelDetached = false;
        panelPosition = "right";
        panelHeightRatio = 0.85;
        panelWidth = 520;
        attachmentStyle = "connected";
        scale = 1;
      };
    };

    settings = builtins.fromJSON (builtins.readFile ../../../assets/shells/noctalia-settings.json);
  };
}
