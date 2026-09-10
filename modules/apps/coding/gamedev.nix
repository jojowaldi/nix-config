{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    godot
    unityhub
    _7zip-zstd
  ];
}
