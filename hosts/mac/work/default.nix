{
  inputs,
  pkgs,
  self,
  ...
}:

{
  imports = with self.modules; [
    ./hardware-config.nix
    ../../spec.nix

    # Base
    inputs
    system.sops
    users.normal

    # Apps / Tools
    apps.coding.code_editor
    apps.tools.terminal
    system.font
  ];

  environment.systemPackages = with pkgs; [
    libiconv
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  hostSpec = {
    hostname = "work";
    users = [
      (inputs.nix-secrets.users.work or inputs.nix-secrets.users.jojowaldi or {
        username = "work";
        secrets_user = "jojowaldi";
      })
    ];
    configPath = "/etc/nix-darwin/nix-config";
  };
}
