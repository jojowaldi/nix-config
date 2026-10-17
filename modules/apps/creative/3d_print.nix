{ inputs, pkgs, pkgsUnstableNoCuda, ... }:

{
  environment.systemPackages = with pkgsUnstableNoCuda; [
    # vtk 9.5.2 is broken in current nixpkgs (PEGTL not found)
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.freecad
    # WebKitGTK dmabuf renderer crashes on Hyprland: "Error 71 (Protocol error)"
    (symlinkJoin {
      name = "orca-slicer";
      paths = [ orca-slicer ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/orca-slicer --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      '';
    })
  ];
}
