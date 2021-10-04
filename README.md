# Artemis | Minimum Viable GitOps
Artemis provides a tested collection of gitops pipeline tools intended to enable pre-infra gitops point of origin.
    
Included:
  - Tekton Pipelines
  - Tekton Dashboard
  - Argo CD

### Install:
  - Install ArgoCD
```sh
kubectl create namespace argocd --dry-run=client -oyaml            | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/argocd | kubectl apply -f -
```
  - Install ArgoCD ApplicationSet controller (beta feature)
```sh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/applicationset/master/manifests/install.yaml
```
  - Set admin password to `admin:admin` (unsafe)
```sh
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "$2a$10$mivhwttXM0U5eBrZGtAG8.VSRL1l9cZNAmaSaqotIzXRBRwID1NT.","admin.passwordMtime": "'$(date +%FT%T)'"}}'
```
  - Port Forward service to localhost
```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
  - Open in Browser @ http://localhost:8080
  - Enroll argocd as an argocd managed application
```sh
kubectl apply -f https://raw.githubusercontent.com/ContainerCraft/Artemis/main/argocd/application.yaml
```
```
kubectl kustomize https://github.com/containercraft/artemis/cert-manager | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/metallb      | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/kong         | kubectl apply -f -
```
  - Optional: Add Kargo Kubevirt Hypervisor
```sh
kubectl create namespace kargo --dry-run=client -oyaml             | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/kargo  | kubectl apply -f -
```
  - Label nodes
```sh
kubectl label nodes --all --overwrite       node-role.kubernetes.io/kubevirt=''
kubectl label nodes --all --overwrite       kargo-zone.containercraft.io/all=''
kubectl label nodes node1 node2 --overwrite kargo-zone.containercraft.io/a=''
kubectl label nodes node2 node3 --overwrite kargo-zone.containercraft.io/b=''
kubectl label nodes node3 node1 --overwrite kargo-zone.containercraft.io/c=''
kubectl label nodes node4       --overwrite kargo-zone.containercraft.io/d=''
```
