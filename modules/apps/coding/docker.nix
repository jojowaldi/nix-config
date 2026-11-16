{ pkgs, ... }:

let
  wrapped-kubernetes-helm =
    with pkgs;
    wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    };
in
{
  environment.systemPackages = with pkgs; [
    docker
    docker-buildx
    docker-compose
    terraform
    k9s
    wrapped-kubernetes-helm
    kubectl
    kubevirt
    kustomize
    helm-ls
    minikube
  ];
}
