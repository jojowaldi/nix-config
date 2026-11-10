{
  pkgs,
  isLinux,
  ...
}:

let
  wrapped-azure-cli = pkgs.azure-cli.withExtensions [ pkgs.azure-cli-extensions.account ];
in
{
  environment.systemPackages =
    with pkgs;
    [
      cargo-expand
      cargo-generate
      cargo-nextest
      (cargo-llvm-cov.overrideAttrs { doCheck = false; }) # upstream tests fail on 0.9.0
      cargo-tauri
      tauri-driver
      cargo-watch
      # FIXME: upstream missing zstd/system libs for cargoUseSystemLibs (0.7.10), revert once fixed
      (dioxus-cli.overrideAttrs (old: {
        dontCargoUseSystemLibs = true;
        buildInputs = (old.buildInputs or [ ]) ++ [ zstd ];
      }))
      postgresql
      git-cliff
      act
      maven
      # FIXME: upstream missing sqlite in buildInputs for cargoUseSystemLibs (2.0.4), revert once fixed
      (sea-orm-cli.overrideAttrs (old: {
        dontCargoUseSystemLibs = true;
        buildInputs = (old.buildInputs or [ ]) ++ [ sqlite ];
      }))
      wasm-pack
      ldproxy
      pkg-config
      gobject-introspection
      #wrapped-azure-cli
      devenv
      espflash
      stackit-cli
      awscli2
      google-cloud-sdk
      pre-commit
      nodejs_26
      bun
      pnpm
      llvmPackages.lld
      wasm-bindgen-cli
      clang.cc
      antigravity-cli
    ]
    ++ (
      if isLinux then
        (with pkgs; [
          # FIXME: upstream missing zstd/system libs for cargoUseSystemLibs (0.4.1), revert once fixed
          (release-plz.overrideAttrs (old: {
            dontCargoUseSystemLibs = true;
            buildInputs = (old.buildInputs or [ ]) ++ [ zstd ];
          }))
          esp-generate
          # FIXME: upstream missing aws-lc/system libs for cargoUseSystemLibs (0.19.0), revert once fixed
          (espup.overrideAttrs {
            dontCargoUseSystemLibs = true;
          })
          probe-rs-tools
          kdePackages.qtdeclarative
        ])
      else
        [ ]
    );

  services.udev.packages = with pkgs; [
    probe-rs-tools
  ];

  users.groups.plugdev = { };

  networking.firewall = {
    allowedTCPPorts = [
      1420
      1421
    ];
  };
}
