{
  config,
  ...
}:

{
  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ config.sops.secrets."store_key/private".path ];
    settings = {
      bind = "[::]:5001";
      priority = 100;
      enable_compression = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;

    virtualHosts."default_server" = {
      locations."/".extraConfig = ''
        proxy_pass http://127.0.0.1:5001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
}
