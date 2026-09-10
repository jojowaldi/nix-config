{ pkgsUnstableNoCuda, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    package = pkgsUnstableNoCuda.jellyfin;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    #makemkv
    mkvtoolnix
    hdr10plus_tool
    ffmpeg-full
  ];
}
