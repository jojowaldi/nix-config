{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cudatoolkit
    libnvidia-container
    egl-wayland
    cudaPackages.cuda_nvrtc
    nvidia-docker
    nvidia-container-toolkit
  ];

  programs.nix-ld.libraries = [
    config.boot.kernelPackages.nvidia_x11.lib32
  ];

  #hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "580.65.06";
    #  sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
    #  openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
    #  settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
    #  usePersistenced = false;
    #};
  };
}
