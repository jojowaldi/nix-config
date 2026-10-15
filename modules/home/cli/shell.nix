{
  pkgs,
  isLinux,
  hostSpec,
  ...
}:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = ''
      if [[ $- == *i* ]]; then
        exec fish
      fi
    '';
  };

  home.sessionVariables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    LIBCLANG_PATH = "/run/current-system/sw/share/nix-ld/lib";
  }
  // (
    if isLinux && !hostSpec.isWsl then
      {
        CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
      }
    else
      { }
  );
}
