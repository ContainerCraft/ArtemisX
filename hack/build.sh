#!/bin/bash
artemisPath="$(pwd)/artemis"
rm -rf ${artemisPath}/*

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
# Tekton Pipelines
tektonPipelineDeployUrl="https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml"
tektonTriggersDeployUrl="https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml"
tektonDashboardDeployUrl="https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml"

echo "---" >> artemis.yml
curl -L ${tektonPipelineDeployUrl} >> artemis.yml

echo "---" >> artemis.yml
curl -L ${tektonTriggersDeployUrl} >> artemis.yml

echo "---" >> artemis.yml
curl -L ${teltonDashboardDeployUrl} >> artemis.yml
