{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    inputs.proton.packages.${stdenv.hostPlatform.system}.default
    prismlauncher
  ];
}
