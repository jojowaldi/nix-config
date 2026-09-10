{ pkgs, pkgsUnstableNoCuda, ... }:

let
  browser = [ "brave-browser.desktop" ];
  editor = [ "nvim.desktop" ];
  media = [ "vlc.desktop" ];
  terminal = [ "alacritty.desktop" ];

  associations = {
    "text/*" = editor;
    "text/plain" = editor;
    "text/html" = browser;

    # "text/html" = browser;
    "application/x-zerosize" = editor; # empty files

    "application/x-shellscript" = editor;
    "application/x-perl" = editor;
    "application/json" = editor;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "application/pdf" = browser;
    "application/mxf" = media;
    "application/sdp" = media;
    "application/smil" = media;
    "application/streamingmedia" = media;
    "application/vnd.apple.mpegurl" = media;
    "application/vnd.ms-asf" = media;
    "application/vnd.rn-realmedia" = media;
    "application/vnd.rn-realmedia-vbr" = media;
    "application/x-cue" = media;
    "application/x-extension-m4a" = media;
    "application/x-extension-mp4" = media;
    "application/x-matroska" = media;
    "application/x-mpegurl" = media;
    "application/x-ogm" = media;
    "application/x-ogm-video" = media;
    "application/x-shorten" = media;
    "application/x-smil" = media;
    "application/x-streamingmedia" = media;

    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/terminal" = terminal;

    "audio/*" = media;
    "video/*" = media;
    "image/*" = browser;

    "application/vnd.jgraph.mxfile" = [ "drawio.desktop" ];
    "application/vnd.jgraph.mxfile.realtime" = [ "drawio.desktop" ];
  };
in
{
  # Module installing brave as default browser
  home.packages = with pkgs; [
    google-chrome
    pkgsUnstableNoCuda.firefox
    brave
    chromium
  ];

  xdg = {
    configFile."mimeapps.list".force = true;

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = associations;
      associations.added = associations;
    };
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };
}
