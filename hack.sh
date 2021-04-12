#!/bin/bash -x
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

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl label node artemis --overwrite node-role.kubernetes.io/master-
kubectl label nodes --all node-role.kubernetes.io/worker
kubectl label nodes --all ingress-ready=true

for namespace in ${NAMESPACES}; do
  echo
  echo ">> Deploying ${namespace}"
  kubectl create --save-config -n ${namespace} -f ${artemisPath}/${namespace}
done
echo


# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
# kubectl create --save-config -n ingress-nginx -f artemis/ingress-nginx/manifest.yml 
# kubectl create --save-config -n kubevirt-hostpath-provisioner -f artemis/kubevirt-hostpath-provisioner/manifest.yml
# kubectl port-forward svc/argocd-server 8080:443
