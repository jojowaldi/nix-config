{ pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];

  systemd.services.docker.serviceConfig.Type = lib.mkForce "simple";
}
