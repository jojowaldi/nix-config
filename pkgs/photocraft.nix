{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxcb,
  vulkan-loader,
  libGL,
}:

rustPlatform.buildRustPackage {
  pname = "photocraft";
  version = "0.12.0-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "photocraft";
    rev = "6a2d027ee2e7ca12afd248544ed2262b0fa078dd";
    hash = "sha256-2MS7ge6Hp+KHmK7i3zZi/fgQfofO+tDPdDqOd2jFZUk=";
  };

  cargoHash = "sha256-5eftgEI1vmfzST9LvXcurWyEOEjk2w6OAFjlx0p3ltg=";

  cargoBuildFlags = [
    "-p"
    "photocraft"
    "-p"
    "photocraft-cli"
  ];

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  # winit/wgpu dlopen these at runtime, so they are not NEEDED entries
  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libxkbcommon
        wayland
        libx11
        libxcursor
        libxi
        libxcb
        vulkan-loader
        libGL
      ]
    } $out/bin/photocraft $out/bin/photocraft-cli
  '';

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.photocraft.desktop -t $out/share/applications
    install -Dm644 packaging/linux/ai.storyteller.photocraft.mime.xml $out/share/mime/packages/ai.storyteller.photocraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  meta = {
    description = "Open-source Rust reimplementation of Photoshop with PSD support";
    homepage = "https://github.com/storytold/photocraft";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "photocraft";
    platforms = lib.platforms.linux;
  };
}
