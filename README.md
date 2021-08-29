# Artemis | Minimum Viable GitOps
Artemis provides a tested collection of gitops pipeline tools intended to enable pre-infra gitops point of origin.
    
Included:
  - Tekton Pipelines
  - Tekton Dashboard
  - Argo CD

### Install:
  - Install
```sh
kubectl create namespace argocd --dry-run=client -oyaml | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis | kubectl apply -f -
```
  - Set admin password to `admin:admin` (unsafe)
```sh
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "$2a$10$mivhwttXM0U5eBrZGtAG8.VSRL1l9cZNAmaSaqotIzXRBRwID1NT.","admin.passwordMtime": "'$(date +%FT%T)'"}}'
```
  - Enroll argocd as an argocd managed application
```sh
kubectl apply -f https://raw.githubusercontent.com/ContainerCraft/Artemis/main/argocd/application.yaml
```
