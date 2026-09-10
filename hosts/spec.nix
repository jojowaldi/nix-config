{ lib, ... }:

let
  userSpecType = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "The username of the host";
      };
      secrets_user = lib.mkOption {
        type = lib.types.str;
        description = "User to find secrets";
      };
      git_user = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The git username";
      };
      git_email = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The git email";
      };
      git_sign_key = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The git signing key";
      };
      ssh_keys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "User ssh keys";
      };
      ssh_config = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "User ssh config";
      };
      ssh_known_hosts = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "User ssh known hosts";
      };
      gpg_pub_key = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Public GPG Key for the user";
      };
      use_yubikey = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use a YubiKey for authentication";
      };
    };
  };
in
{
  options.hostSpec = {
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    isMinimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a minimal host";
    };
    users = lib.mkOption {
      type = lib.types.listOf userSpecType;
      default = [ ];
      description = "Users for this host";
    };
    configPath = lib.mkOption {
      type = lib.types.str;
      default = "/etc/nixos/nix-config";
      description = "Path to the nix-config directory";
    };
    hyprlandMonitorConfig = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Hyprland monitor configuration";
    };
    hyprlandHiDpiFix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to apply the HiDPI fix for Hyprland";
    };
  };

  # Used for home-manager configuration and is automatically set in user profiles. DO NOT set manually.
  options.userSpec = lib.mkOption {
    type = userSpecType;
    description = "User info";
    default = {
      username = "";
    };
  };
}
