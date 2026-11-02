{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    ansible
    terraform
    minikube
    # minikube bringt einen eigenen bin/kubectl mit, der immer den Cluster "minikube" nimmt
    (lib.hiPrio kubectl)
    k9s
  ];
}
