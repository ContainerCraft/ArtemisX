echo "
######################################################################
######################################################################
######################################################################
"
kubectl label node artemis --overwrite node-role.kubernetes.io/master-
kubectl label node artemis --overwrite node-role.kubernetes.io/worker
kubectl label node artemis --overwrite ingress-ready=true
kubectl patch storageclass hostpath-provisioner -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl create --save-config -f artemis.yml
kubectl apply --overwrite -f artemis.yml
