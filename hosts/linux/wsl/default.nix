{
  inputs,
  self,
  ...
}:

{
  imports = with self.modules; [
    inputs.nixos-wsl.nixosModules.default
    ../../spec.nix

    ../../profiles/general.nix

    system.general
    system.locale

    apps.nix
    apps.libs # nix-ld, needed by the VS Code / Zed remote server
    apps.tools.cli
    apps.coding.cli_tools
    apps.coding.lang
    apps.coding.docker
  ];

  # defaultUser stays "nixos"
  wsl.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "wsl";

  hostSpec = {
    hostname = "wsl";
    isWsl = true;
    users = [
      {
        username = "nixos";
        secrets_user = "";
        git_user = "johannesatsomic";
        git_email = "180259399+johannesatsomic@users.noreply.github.com";
      }
    ];
  };
}
