{ ... }:

{
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.gvfs.enable = true;
}
