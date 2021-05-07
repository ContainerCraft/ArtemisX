sudo $(pwd)/bin/kind create cluster -v=9 --config $(pwd)/kind/config.yml

mkdir -p $(pwd)/kube
sudo cp -f /root/.kube/config $(pwd)/kube/artemis
sudo chown $USER:$USER -R $(pwd)
export KUBECONFIG=$(pwd)/kube/artemis

kubectl cluster-info --context kind-artemis

# kind delete clusters kargo
