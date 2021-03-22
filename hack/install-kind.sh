kubectl_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
mkdir $(pwd)/bin

curl -L --output $(pwd)/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl"
curl -L --output $(pwd)/bin/kind "https://kind.sigs.k8s.io/dl/v0.10.0/kind-$(uname)-amd64"

chmod +x ./bin/*
export PATH=$PATH:$(pwd)/bin
kind version
kubectl version --client --short
kind create cluster -v=9 --config $(pwd)/kind/artemis.yml
kubectl cluster-info --context kind-artemis
# kind delete clusters kargo
