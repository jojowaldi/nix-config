{
  pkgs,
  isLinux,
  ...
}:

{
  programs = (
    if isLinux then
      {
        nix-ld = {
          enable = true;
          libraries = with pkgs; [
            at-spi2-atk
            atkmm
            cairo
            gdk-pixbuf
            glib
            gtk3
            harfbuzz
            librsvg
            librsvg.dev
            libsoup_3
            pango
            webkitgtk_4_1
            openssl
            stdenv.cc.cc.lib
            nss
            libclang.lib

            # bevy
            alsa-lib-with-plugins
            vulkan-loader
            openxr-loader
            libGL
            libx11
            libxcursor
            libxi
            libxrandr
            libxkbcommon
            libudev-zero
            udev
            wayland.dev
            libgcc.lib
            zlib
            zstd
            curl
            stdenv.cc.cc
            bzip2
            libxml2
            acl
            libsodium
            util-linux
            xz
            systemd
          ];
        };
      }
    else
      { }
  );
}
