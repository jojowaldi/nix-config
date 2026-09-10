{
  pkgs,
  isLinux,
  inputs,
  lib,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    [
      trunk
      nano
      home-manager
      ripgrep
      curl
      wget
      fd
      dust
      fzf
      jq
      tree
      unzip
      zip
      coreutils
      just
      rsync
      cmatrix
      neo-cowsay
      htop
      btop
      inetutils
      nettools
      speedtest-cli
      tealdeer
      whois
      ssh-to-age
      yq-go
      age
      pciutils
      nss
      openssl
      bat
      eza
      xh
      hyperfine
      tokei
      dig
      nmap
      openssl
      arp-scan
      man-pages
      man-pages-posix
      sops
      pam_u2f
      libfido2
      haskellPackages.hashable
      cachix
      fish
      inputs.hibernation.packages.${stdenv.hostPlatform.system}.default
      socat
    ]
    ++ (
      if isLinux then
        (with pkgs; [
          inotify-tools
          os-prober
          traceroute
          waypipe
          tpm2-tss
          tpm2-tools
        ])
      else
        [ ]
    );

  programs.direnv = {
    silent = true;
    enable = true;
    nix-direnv.enable = true;
    loadInNixShell = true;
  }
  // (
    if isLinux then
      {
        enableFishIntegration = true;
      }
    else
      { }
  );

  documentation = (
    if isLinux then
      {
        man.cache.enable = lib.mkForce false;
      }
    else
      { }
  );
}
