echo "
######################################################################
######################################################################
######################################################################
"
kubectl label node edge --overwrite node-role.kubernetes.io/master-
kubectl label node edge --overwrite node-role.kubernetes.io/worker
kubectl label node edge --overwrite ingress-ready=true
kubectl create --save-config -f artemis.yml
kubectl apply --overwrite -f artemis.yml
