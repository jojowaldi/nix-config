{ pkgsUnstableNoCuda, ... }:

{
  environment.systemPackages = with pkgsUnstableNoCuda; [
    # vtk 9.5.2 is broken in current nixpkgs (PEGTL not found)
    #freecad
    orca-slicer
  ];
}
