{
  pkgs,
  isLinux,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    [
      # CC
      gcc
      gnumake
      cmake
      autoconf
      automake
      libtool
      # Python setup
      python313
      imath
      pystring
      uv
      # Rust
      rustup
      # Go
      go
      # Java
      jdk25
      gradle
      # Protobuf
      protobuf
      # Odin
      odin
      # Gleam
      gleam
      beamPackages.erlang
      rebar
    ]
    ++ (
      if isLinux then
        (with pkgs; [
          # Android
          android-tools
          scrcpy
          sdkmanager
          virtualgl
        ])
      else
        [ ]
    );
}
