{ lib, ... }:

let
  skipPaths = [ "default.nix" ];

  constructModules =
    path:
    lib.foldl (acc: item: acc // item) { } (
      lib.mapAttrsToList (
        rawName: value:
        let
          name = lib.removeSuffix ".nix" rawName;
          fullPath = path + "/${rawName}";
        in
        if (builtins.elem fullPath skipPaths == false) then
          {
            "${name}" = if value != "directory" then import fullPath else constructModules fullPath;
          }
        else
          { }
      ) (builtins.readDir path)
    );
in
constructModules ./.
