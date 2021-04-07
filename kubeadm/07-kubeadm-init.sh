#!/bin/bash -x

kubeadm reset
runPwd=$(pwd)
mkdir -p /etc/artemis
cd /etc/artemis
kubeadm init \
    --node-name artemis \
    --config /root/artemis/kubeadm/config/kubeadm.yaml \
    --cri-socket /var/run/containerd/containerd.sock \
    $@

#   --apiserver-cert-extra-sans="artemis.codectl.io" \
#   --apiserver-cert-extra-sans="api.artemis.codectl.io" \
#   --log-file-max-size=64 \
#   --log-file='/var/log/artemis.log' \

cd ${runPwd}

sleep 10

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl label nodes artemis node-role.kubernetes.io/worker=""

#   --cgroup-driver systemd \
#--cri-socket /var/run/crio/crio.sock \
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
