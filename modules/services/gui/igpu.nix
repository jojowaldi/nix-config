{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      intel-ocl
      intel-vaapi-driver
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.intel-vaapi-driver
      driversi686Linux.intel-media-driver
    ];
  };

  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelModules = [ "xe" ];
}
