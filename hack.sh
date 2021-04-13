#!/bin/bash -ex
clear && echo "
####################################
# Artemis -- Minimum Viable GitOps #
####################################
"
artemisPath="$(pwd)/artemis"
NAMESPACES="\
  argocd \
  ingress-nginx \
  kubevirt-hostpath-provisioner \
"

for namespace in ${NAMESPACES}; do
  echo
  echo ">> Deploying ${namespace}"
  kubectl apply -n ${namespace} -f ${artemisPath}/${namespace}
 #kubectl create --save-config -n ${namespace} -f ${artemisPath}/${namespace}
done
echo
kubectl label nodes --overwrite --all node-role.kubernetes.io/worker=""
kubectl taint nodes --overwrite --all node-role.kubernetes.io/master-
kubectl label nodes --overwrite --all ingress-ready=true

# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
# kubectl create --save-config -n ingress-nginx -f artemis/ingress-nginx/manifest.yml 
# kubectl create --save-config -n kubevirt-hostpath-provisioner -f artemis/kubevirt-hostpath-provisioner/manifest.yml
# kubectl port-forward svc/argocd-server 8080:443
