{ pkgs, config, lib, ... }: # Wichtig: 'lib' in den Argumenten hinzufügen!

{
  programs.gpg = {
    enable = true;

    # Erstellt die Liste nur, wenn der String nicht leer ist
    publicKeys = lib.optional (config.userSpec.gpg_pub_key != "") {
      text = config.userSpec.gpg_pub_key;
      trust = 5;
    };

    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;

    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  home.packages = with pkgs; [ gnupg ];
}
