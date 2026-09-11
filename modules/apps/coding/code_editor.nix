{ pkgs, isLinux, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      #jetbrains-toolbox
      zed-editor
      antigravity
    ]
    ++ (
      if isLinux then
        [
          #android-studio
        ]
      else
        [ ]
    );

  programs.ghidra = {
    enable = true;
    gdb = true;
  };
}
