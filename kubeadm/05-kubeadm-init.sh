#!/bin/bash -x
runPwd=$(pwd)
cat <<EOF > /tmp/kubeadm.yaml
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
maxPods: 64
cgroupDriver: systemd
staticPodPath: /etc/kubernetes/manifests
serializeImagePulls: false
#featureGates:
#  CPUManager: true
#cpuManagerPolicy: static
---
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: $(ip -4 -o addr show enp1s0 | awk -F'[/ ]' '{print $7}')
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/containerd/containerd.sock
  name: qotom
# taints:
# - effect: NoSchedule
#   key: node-role.kubernetes.io/master
---
apiVersion: kubeadm.k8s.io/v1beta2
apiServer:
  timeoutForControlPlane: 6m0s
certificatesDir: /etc/kubernetes/pki
clusterName: qotom
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: k8s.gcr.io
kind: ClusterConfiguration
kubernetesVersion: v1.20.0
networking:
  dnsDomain: codectl.local
  serviceSubnet: 192.96.0.0/12
scheduler: {}
EOF

systemctl stop kubelet
sleep 5
kubeadm reset
systemctl start kubelet
sleep 10

mkdir -p /etc/qotom
cd /etc/qotom
kubeadm init \
    --node-name qotom \
    --config /tmp/kubeadm.yaml \
    --cri-socket /var/run/containerd/containerd.sock

#   --apiserver-cert-extra-sans="artemis.codectl.io" \
#   --apiserver-cert-extra-sans="api.artemis.codectl.io" \
#   --log-file-max-size=64 \
#   --log-file='/var/log/artemis.log' \

cd ${runPwd}
mkdir -p $HOME/.kube
sudo cp -ifr /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/root/.kube/config
sleep 10
kubectl get nodes

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
