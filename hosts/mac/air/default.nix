{ inputs, ... }:

{
  imports = [
    ./hardware-config.nix
    ../../spec.nix

    ../../profiles/general.nix
    ../../profiles/darwin/system.nix
    ../../profiles/darwin/services.nix
    ../../profiles/darwin/apps.nix
  ];

  hostSpec = {
    hostname = "air";
    users = [ inputs.nix-secrets.users.jojowaldi ];
    configPath = "/etc/nix-darwin/nix-config";
  };
}
