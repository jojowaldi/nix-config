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
      cargo-llvm-cov
      cargo-tauri
      tauri-driver
      cargo-watch
      dioxus-cli
      postgresql
      bun2nix
      git-cliff
      act
      maven
      sea-orm-cli
      wasm-pack
      ldproxy
      pkg-config
      gobject-introspection
      #wrapped-azure-cli
      devenv
      espflash
      stackit-cli
      awscli2
      pre-commit
      nodejs_26
      bun
      pnpm
      llvmPackages.lld
      wasm-bindgen-cli
      clang.cc
      slintcn
    ]
    ++ (
      if isLinux then
        (with pkgs; [
          release-plz
          esp-generate
          espup
          probe-rs-tools
          kdePackages.qtdeclarative
          strix
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
