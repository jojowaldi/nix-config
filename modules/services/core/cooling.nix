{ pkgs, ... }:

{
  programs.coolercontrol = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  boot.kernelModules = [
    "nct6775"
  ];
}
