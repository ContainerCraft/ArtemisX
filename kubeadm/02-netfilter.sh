
#######################################################################################
# Install kubectl
export verKubectl=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${verKubectl}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/${verKubectl}/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check




#######################################################################################
# install kubeadm https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
