#!/bin/bash
artemisPath="$(pwd)/artemis"
rm -rf ${artemisPath}/*

################################################################################
# Nginx Ingress
manifests="${artemisPath}/ingress-nginx"
nginxIngressDeployUrl="https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml"
#nginxIngressDeployUrl="https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml"
mkdir -p ${manifests}

echo "---"                        >> ${manifests}/manifest.yml
curl -L ${nginxIngressDeployUrl}  >> ${manifests}/manifest.yml

################################################################################
# Host Path Provisioner
manifests="${artemisPath}/kubevirt-hostpath-provisioner"
hostpathVersion=$(curl --silent "https://api.github.com/repos/kubevirt/hostpath-provisioner/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
hostPathDeployUrl="https://github.com/kubevirt/hostpath-provisioner/releases/download/${hostpathVersion}/kubevirt-hostpath-provisioner.yaml"
hostPathSecUrl="https://github.com/kubevirt/hostpath-provisioner/releases/download/${hostpathVersion}/kubevirt-hostpath-security-constraints.yaml"
mkdir -p ${manifests}

echo "---"                        >> ${manifests}/manifest.yml
curl -L ${hostPathDeployUrl}      >> ${manifests}/manifest.yml

echo "---"                        >> ${manifests}/manifest.yml
curl -L ${hostPathSecUrl}         >> ${manifests}/manifest.yml

sed -i -e :a -e '$d;N;2,25ba' -e 'P;D' artemis/kubevirt-hostpath-provisioner/manifest.yml

echo "---"                        >> ${manifests}/manifest.yml
cat patch/hostpath-default.yml    >> ${manifests}/manifest.yml

################################################################################
# ArgoCD
manifests="${artemisPath}/argocd"
argoVersion=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
argoInstallUrl="https://raw.githubusercontent.com/argoproj/argo-cd/${argoVersion}/manifests/install.yaml"
mkdir -p ${manifests}

echo "---"                        >> ${manifests}/manifest.yml
cat patch/argo-namespace.yml      >> ${manifests}/manifest.yml

echo "---"                        >> ${manifests}/manifest.yml
curl -L ${argoInstallUrl}         >> ${manifests}/manifest.yml

echo "---"                        >> ${manifests}/manifest.yml
cat patch/argo-ingress-https.yml  >> ${manifests}/manifest.yml

echo "---"                        >> ${manifests}/manifest.yml
cat patch/argo-ingress-grpc.yml   >> ${manifests}/manifest.yml

#echo "---"                        >> ${manifests}/manifest.yml
#cat patch/argo-server-patch.yml   >> ${manifests}/manifest.yml

################################################################################
# LocalPath Provisioner Default Storage Class
#localPathDeployUrl="https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml"

#echo "---" >> artemis.yml
#curl -L ${localPathDeployUrl} >> artemis.yml

#echo "---" >> artemis.yml
#cat patch/localpath.yml >> artemis.yml

################################################################################
# Tekton Pipelines
#tektonPipelineDeployUrl="https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml"
#tektonTriggersDeployUrl="https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml"
#tektonDashboardDeployUrl="https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml"

#echo "---" >> artemis.yml
#curl -L ${tektonPipelineDeployUrl} >> artemis.yml

#echo "---" >> artemis.yml
#curl -L ${tektonTriggersDeployUrl} >> artemis.yml

#echo "---" >> artemis.yml
#curl -L ${tektonDashboardDeployUrl} >> artemis.yml
