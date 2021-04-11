#!/bin/bash

rcVersion="2.0.0"
argoVersion="${rcVersion}"
#argoVersion=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
hostpathVersion=$(curl --silent "https://api.github.com/repos/kubevirt/hostpath-provisioner/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

hostPathDeployUrl="https://github.com/kubevirt/hostpath-provisioner/releases/download/${hostpathVersion}/kubevirt-hostpath-provisioner.yaml"
hostPathSecUrl="https://github.com/kubevirt/hostpath-provisioner/releases/download/${hostpathVersion}/kubevirt-hostpath-security-constraints.yaml"

localPathDeployUrl="https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml"

argoInstallUrl="https://raw.githubusercontent.com/argoproj/argo-cd/v${argoVersion}/manifests/install.yaml"

nginxIngressDeployUrl="https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml"

tektonPipelineDeployUrl="https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml"
tektonTriggersDeployUrl="https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml"
tektonDashboardDeployUrl="https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml"

echo "---" >> artemis.yml
cat manifests/artemis-namespace.yml >> artemis.yml

################################################################################
# Nginx Ingress
echo "---" >> artemis.yml
curl -L ${nginxIngressDeployUrl} >> artemis.yml

################################################################################
# Host Path Provisioner
#echo "---" >> artemis.yml
#curl -L ${hostPathDeployUrl} >> artemis.yml

#echo "---" >> artemis.yml
#curl -L ${hostPathSecUrl} >> artemis.yml

#echo "---" >> artemis.yml
#cat manifests/hostpath.yml >> artemis.yml

################################################################################
# LocalPath Provisioner Default Storage Class
echo "---" >> artemis.yml
curl -L ${localPathDeployUrl} >> artemis.yml

echo "---" >> artemis.yml
cat patch/localpath.yml >> artemis.yml

################################################################################
# ArgoCD
echo "---" >> artemis.yml
curl -L ${argoInstallUrl} >> artemis.yml

#echo "---" >> artemis.yml
#cat patch/argocd-server-patch.yml >> artemis.yml

echo "---" >> artemis.yml
cat manifests/argo-ingress-https.yml >> artemis.yml

echo "---" >> artemis.yml
cat manifests/argo-ingress-grpc.yml >> artemis.yml

################################################################################
# Tekton Pipelines
#echo "---" >> artemis.yml
#curl -L ${tektonPipelineDeployUrl} >> artemis.yml

#echo "---" >> artemis.yml
#curl -L ${tektonTriggersDeployUrl} >> artemis.yml

#echo "---" >> artemis.yml
#curl -L ${tektonDashboardDeployUrl} >> artemis.yml
