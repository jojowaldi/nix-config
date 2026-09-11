{
  lib,
  config,
  inputs,
  isLinux,
  ...
}:

let
  sopsFolder = toString inputs.nix-secrets + "/sops";
  platform = if isLinux then "nixos" else "darwin";
  platformModules = "${platform}Modules";

  home =
    user:
    if isLinux then
      (if user.username == "root" then "/root" else "/home/${user.username}")
    else
      "/Users/${user.username}";
in
{
  imports = [
    inputs.sops-nix.${platformModules}.sops
  ];

  sops = {
    defaultSopsFile = "${sopsFolder}/${config.hostSpec.hostname}.yaml";
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };

  sops.secrets =
    lib.foldl
      (
        acc: spec:
        acc
        // {
          # These age keys are are unique for the user on each host and are generated on their own (i.e. they are not derived
          # from an ssh key).
          "keys/age_${spec.secrets_user}" = {
            owner = config.users.users.${spec.username}.name;
            #inherit (config.users.users.${spec.username}) group;
            # We need to ensure the entire directory structure is that of the user...
            path = "${home spec}/.config/sops/age/keys.txt";
            key = "keys/age";
          };
          # extract password/username to /run/secrets-for-users/ so it can be used to create the user
          "passwords/${spec.secrets_user}" = {
            sopsFile = "${sopsFolder}/shared.yaml";
            neededForUsers = true;
          };
        }
      )
      {
      }
      config.hostSpec.users;

  system.activationScripts = lib.foldl (
    acc: spec:
    acc
    // {
      "sopsSetAgeKeyOwnership_${spec.username}" =
        let
          ageFolder = "${home spec}/.config/sops/age";
        in
        ''
          mkdir -p ${ageFolder} || true
        '';
    }
  ) { } config.hostSpec.users;
}

