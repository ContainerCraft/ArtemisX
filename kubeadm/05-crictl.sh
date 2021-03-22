pathDir=""
CRI_RELEASE="$(\
        curl -s 'https://github.com/kubernetes-sigs/cri-tools/releases/latest' \
        | awk -F'[v\&\"]' '/releases/{print $3}' \
    )"
CRI_RELEASE_URL="https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRI_RELEASE}/crictl-v${CRI_RELEASE}-linux-amd64.tar.gz"
sudo mkdir -p /opt/cni/bin
curl -L "${CRI_RELEASE_URL}" | sudo tar -C /opt/cni/bin -xz
