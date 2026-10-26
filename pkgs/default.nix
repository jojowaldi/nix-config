final: prev: {
  deej = final.callPackage ./deej.nix { };
  photocraft = final.callPackage ./photocraft.nix { };
}
