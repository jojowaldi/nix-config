{
  inputs,
  pkgs,
  config,
  ...
}:

let
  vicinaeChromiumHost = pkgs.writeText "com.vicinae.vicinae.json" (
    builtins.toJSON {
      name = "com.vicinae.vicinae";
      description = "IPC Native Messaging Host";
      path = "${config.programs.vicinae.package}/libexec/vicinae/vicinae-browser-link";
      type = "stdio";
      allowed_origins = [
        "chrome-extension://kcmipingpfbohfjckomimmahknoddnke/"
      ];
    }
  );
in
{
  imports = [
    inputs.custom-nixpkgs.vicinae.homeManagerModules.default
  ];

  programs.vicinae = {
    enable = true;
    package = pkgs.vicinae-with-soulver;

    systemd = {
      enable = true;
      autoStart = true;
    };

    extensions = with pkgs; [
      vicinae-nix
      vicinae-power-profile
      vicinae-it-tools
      vicinae-port-killer
      #systemd
      vicinae-hypr-keybinds
      vicinae-vscode-recents
      vicinae-zed-recents
      vicinae-protondb-search
      vicinae-jetbrains-recent-projects
      vicinae-hyprland-monitors
      vicinae-hypr
      vicinae-timer
      vicinae-npm
      google-vicinae-extension
      spotify-player-vicinae-extension
      whois-vicinae-extension
      random-data-generator
      qrcode-generator
      home-assistant-vicinae-extension
      can-i-use
      lucide-icons-search
      search-mdn
    ];
  };

  home.file.".config/vicinae/settings.json".source = ../../../assets/vicinae.json;

  xdg.configFile = {
    # Chromium / Brave / Vivaldi etc — add whichever browsers you use
    "chromium/NativeMessagingHosts/com.vicinae.vicinae.json".source = vicinaeChromiumHost;
    "google-chrome/NativeMessagingHosts/com.vicinae.vicinae.json".source = vicinaeChromiumHost;
    "BraveSoftware/Brave-Browser/NativeMessagingHosts/com.vicinae.vicinae.json".source =
      vicinaeChromiumHost;
  };

  home.packages = with pkgs; [
    sqlite
  ];

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../../assets/hyprland/vicinae.lua;
}
