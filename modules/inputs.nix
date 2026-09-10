{ inputs, pkgs, ... }:

{
  _module.args = {
    pkgsUnstableNoCuda = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}
