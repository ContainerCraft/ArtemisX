#!/bin/bash

pathRun="$(pwd)"
pathDir="/usr/local/bin"

K8S_RELEASE_STABLE="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
K8S_RELEASE_GIT="$(\
        curl -s 'https://github.com/kubernetes/release/releases' \
	| awk -F'[v\&\"]' '/tag_name/{print $3; exit}' 2>/dev/null \
    )"

K8S_DOWNLOAD_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_RELEASE_STABLE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}"
KUBERNETES_RELEASE_URL="https://raw.githubusercontent.com/kubernetes/release/v${K8S_RELEASE_GIT}/cmd/kubepkg/templates/latest"

# Download kubeadm,kubelet,kubectl
cd ${pathDir}
curl --location --remote-name-all ${K8S_DOWNLOAD_URL}
chmod +x ${pathDir}/{kubeadm,kubelet,kubectl}
cd ${pathRun}

# Download kubelet systemd unit file and systemd unit config
mkdir -p /etc/systemd/system/kubelet.service.d
systemctl stop kubelet

curl -sSL "${KUBERNETES_RELEASE_URL}/deb/kubeadm/10-kubeadm.conf" \
    | sed "s:/usr/bin:${pathDir}:g" \
    | tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

curl -sSL "${KUBERNETES_RELEASE_URL}/deb/kubelet/lib/systemd/system/kubelet.service" \
    | sed "s:/usr/bin:${pathDir}:g" \
    | tee /etc/systemd/system/kubelet.service

systemctl daemon-reload
systemctl enable --now kubelet
