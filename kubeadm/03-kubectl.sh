#######################################################################################
# Install kubectl
dir_bin="../bin"
bitKubectl="${dir_bin}/kubectl"
verKubectl="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
curl --output ${binKubectl} -L "https://dl.k8s.io/release/${verKubectl}/bin/linux/amd64/kubectl"
chmod +x ${binKubectl}

#curl -L "https://dl.k8s.io/${verKubectl}/bin/linux/amd64/kubectl.sha256"
#echo "$(<kubectl.sha256) kubectl" | sha256sum --check

# install -o ${USER} -g ${USER} -m 0755 ../bin/kubectl ~/.local/bin/kubectl
# source <(kubectl completion bash)

#######################################################################################
# install kubeadm https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
