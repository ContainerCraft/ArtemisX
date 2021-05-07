kind_version="$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | awk -F '["v,]' '/tag_name/{print $5}')"
kubectl_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

mkdir $(pwd)/bin

# Download kubectl binary
curl -L --output $(pwd)/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl"
curl -L --output $(pwd)/bin/kind    "https://kind.sigs.k8s.io/dl/v${kind_version}/kind-$(uname)-amd64"

chmod +x ./bin/*
export PATH=$PATH:$(pwd)/bin

kind version
kubectl version --client --short
