CNI_VERSION="$(\
        curl -s https://github.com/containernetworking/plugins/releases/latest \
        | awk -F'[v\&\"]' '/releases/{print $3}' \
    )"
cni_release_url="https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}/cni-plugins-linux-amd64-v${CNI_VERSION}.tgz"
sudo mkdir -p /opt/cni/bin
curl -L "${cni_release_url}" | sudo tar -C /opt/cni/bin -xz
