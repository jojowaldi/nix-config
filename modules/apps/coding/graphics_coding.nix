{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vulkan-caps-viewer
    vulkan-tools
    vulkan-utility-libraries
    vulkan-validation-layers
    vulkan-extension-layer
    renderdoc
  ];
}
