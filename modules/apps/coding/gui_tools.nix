{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    dbeaver-bin
    postman
    insomnia
    wireshark
  ];
}
