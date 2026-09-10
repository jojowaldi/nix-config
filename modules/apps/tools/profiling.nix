{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    perf
    valgrind
    kdePackages.kcachegrind
  ];
}
