{
  config,
  pkgs,
  isLinux,
  ...
}:

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "*" = {
        userKnownHostsFile = toString (pkgs.writeText "known_hosts" config.userSpec.ssh_known_hosts);
        addKeysToAgent = "yes";
      };
    }
    // config.userSpec.ssh_config;
  };

  services = (
    if isLinux then
      {
        ssh-agent = {
          enable = true;
        };
      }
    else
      { }
  );
}
