{
  lib,
  config,
  inputs,
  pkgs,
  pkgsUnstableNoCuda,
  isLinux,
  self,
  ...
}:

let
  hostSpec = config.hostSpec;
  pubKeys = lib.filesystem.listFilesRecursive ../../keys;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  platform = if isLinux then "nixos" else "darwin";
  platformModules = "${platform}Modules";
in
{
  imports = [
    inputs.home-manager.${platformModules}.home-manager
  ];

  users = {
    users = lib.foldl (
      acc: spec:
      acc
      // {
        "${spec.username}" = {
          openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

          shell = pkgs.fish;
        }
        // (
          if isLinux then
            {
              isNormalUser = spec.username != "root";
              extraGroups = lib.flatten [
                "wheel"
                (ifTheyExist [
                  "audio"
                  "video"
                  "docker"
                  "git"
                  "vboxusers"
                  "libvirtd"
                  "kvm"
                  "networkmanager"
                  "scanner" # for print/scan"
                  "lp" # for print/scan"
                  "gamemode"
                  "dialout" # for betaflight
                  "adbusers" # for android adb
                  "jellyfin"
                  "disk" # rpi-imager
                  "greeter" # dms greeter
                  "plugdev" # for udev rules
                ])
              ];
              hashedPasswordFile = lib.mkIf (
                !hostSpec.isMinimal
              ) config.sops.secrets."passwords/${spec.username}".path;
            }
          else
            {
              home = "/Users/${spec.username}";
            }
        );
      }
    ) { } hostSpec.users;
  }
  // (
    if isLinux then
      {
        mutableUsers = false;
      }
    else
      { }
  );

  home-manager = {
    extraSpecialArgs = {
      inherit
        pkgs
        inputs
        pkgsUnstableNoCuda
        isLinux
        self
        ;
      hostSpec = config.hostSpec;
    };

    backupFileExtension = "bak";

    users = lib.foldl (
      acc: userSpec:
      acc
      // {
        "${userSpec.username}" = {
          home.stateVersion = "26.05";

          imports = lib.flatten (
            lib.optional (!hostSpec.isMinimal) [
              (
                { ... }:

                {
                  config.userSpec = userSpec;
                  imports = [
                    ../../hosts/spec.nix
                    (lib.custom.relativeToRoot "hosts/users/${userSpec.username}.nix")
                  ];
                }
              )
            ]
          );
        };
      }
    ) { } hostSpec.users;
  };
}
