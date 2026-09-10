{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-config.nix

    ../../spec.nix

    # Base
    ../../../modules/inputs.nix
    ../../../modules/sops.nix
    ../../../modules/users/normal.nix
    # Profiles

    ../../../modules/profiles/apps/base.nix
    ../../../modules/apps/code_editor.nix
    ../../../modules/apps/terminal.nix
    ../../../modules/system/services/font.nix
  ];

  environment.systemPackages = with pkgs; [
    libiconv
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  hostSpec = {
    hostname = "work";
    users = [
      inputs.nix-secrets.users.work
    ];
    configPath = "/etc/nix-darwin/nix-config";
  };
}
