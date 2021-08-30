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
kubectl create namespace argocd --dry-run=client -oyaml                  | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/cert-manager | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/metallb      | kubectl apply -f -
kubectl kustomize https://github.com/containercraft/artemis/kong         | kubectl apply -f -
```
  - Optional: Add Kargo Kubevirt Hypervisor
```sh
kubectl taint nodes --overwrite --all node-role.kubernetes.io/master-
kubectl label nodes --all --overwrite node-role.kubernetes.io/worker=''
kubectl label nodes --all --overwrite node-role.kubernetes.io/kubevirt=''
kubectl kustomize https://github.com/containercraft/artemis/kargo        | kubectl apply -f -
```
