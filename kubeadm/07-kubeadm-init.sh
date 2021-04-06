#!/bin/bash -x

runPwd=$(pwd)
mkdir -p /etc/artemis
cd /etc/artemis
kubeadm init \
    --token-ttl 0 \
    --add-dir-header \
    --node-name artemis \
    --log-file-max-size=64 \
    --apiserver-bind-port 6443 \
    --service-cidr 192.96.0.0/12 \
    --log-file='/var/log/artemis.log' \
    --cri-socket /var/run/crio/crio.sock \
    --apiserver-advertise-address="10.0.0.253" \
    --apiserver-cert-extra-sans="artemis.codectl.io" \
    --apiserver-cert-extra-sans="api.artemis.codectl.io" \
    $@

cd ${runPwd}

sleep 10

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl label nodes artemis node-role.kubernetes.io/worker=""

#   --config kubeadm.conf \
#  mkdir -p $HOME/.kube
#  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#  sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
#Alternatively, if you are the root user, you can run:
#
#  export KUBECONFIG=/etc/kubernetes/admin.conf
#
#You should now deploy a pod network to the cluster.
#Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#  https://kubernetes.io/docs/concepts/cluster-administration/addons/
