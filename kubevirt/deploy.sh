#!/bin/bash -ex
#################################################################################
networkaddonsVersion=$(curl --silent "https://api.github.com/repos/kubevirt/cluster-network-addons-operator/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
networkaddonsUrl="https://github.com/kubevirt/cluster-network-addons-operator/releases/download/${networkaddonsVersion}"
namespace="${networkaddonsUrl}/namespace.yaml"
crd="${networkaddonsUrl}/network-addons-config.crd.yaml"
operator="${networkaddonsUrl}/operator.yaml"

mkdir -p networkaddons
curl -L ${namespace} > networkaddons/namespace.yaml
curl -L ${crd} > networkaddons/network-addons-config.crd.yaml
curl -L ${operator} > networkaddons/operator.yaml
kubectl apply -f networkaddons

#################################################################################
cdiVersion=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
cdi_cr="https://github.com/kubevirt/containerized-data-importer/releases/download/$cdiVersion/cdi-cr.yaml"
cdi_operator="https://github.com/kubevirt/containerized-data-importer/releases/download/$cdiVersion/cdi-operator.yaml"

mkdir -p importer
curl -L ${cdi_operator} > importer/cdi-operator.yaml
curl -L ${cdi_cr} > importer/cdi-cr.yaml
kubectl apply -f importer

#################################################################################
hostpathVersion=$(curl -sL https://api.github.com/repos/kubevirt/hostpath-provisioner-operator/releases/latest \
                  | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
hostpathNamespaceUrl="https://github.com/kubevirt/hostpath-provisioner-operator/releases/download/${hostpathVersion}/namespace.yaml"
hostpathOperatorUrl="https://github.com/kubevirt/hostpath-provisioner-operator/releases/download/${hostpathVersion}/operator.yaml"
hostpathCrUrl="https://github.com/kubevirt/hostpath-provisioner-operator/releases/download/${hostpathVersion}/hostpathprovisioner_cr.yaml"
hostpathStorageClassUrl="https://github.com/kubevirt/hostpath-provisioner-operator/releases/download/${hostpathVersion}/storageclass-wffc.yaml"
mkdir -p /var/hpvolumes
mkdir -p hostpath
curl -L ${hostpathNamespaceUrl} > hostpath/namespace.yaml
curl -L ${hostpathOperatorUrl} > hostpath/operator.yaml
curl -L ${hostpathStorageClassUrl} > hostpath/storageclass-wffc.yaml
rm hostpath/hostpathprovisioner-cr.yaml -rf
kubectl apply -n hostpath-provisioner -f hostpath
sleep 3
curl -L ${hostpathCrUrl} > hostpath/hostpathprovisioner_cr.yaml
kubectl apply -n hostpath-provisioner -f hostpath

mkdir -p aux
curl -L "https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/cert-manager.yaml" > aux/cert-manager.yaml
curl -L "https://raw.githubusercontent.com/kubevirt/hyperconverged-cluster-operator/master/deploy/cert-manager.yaml" > aux/cluster_roles.yaml
kubectl apply -f aux 
kubectl -n cert-manager wait deployment/cert-manager --for=condition=Available --timeout="300s"
kubectl -n cert-manager wait deployment/cert-manager-webhook --for=condition=Available --timeout="300s"

#################################################################################
kubevirtVersion=$(curl -sL https://api.github.com/repos/kubevirt/kubevirt/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
kubevirtUrl="https://github.com/kubevirt/kubevirt/releases/download/${kubevirtVersion}"
kubevirtOperator="${kubevirtUrl}/kubevirt-operator.yaml"
kubevirtCr="${kubevirtUrl}/kubevirt-cr.yaml"
mkdir -p kubevirt
curl -L ${kubevirtOperator} > kubevirt/operator.yaml
rm kubevirt/cr.yaml -rf
kubectl apply -n kubevirt -f kubevirt
sleep 3
curl -L ${kubevirtCr} > kubevirt/cr.yaml
kubectl apply -n kubevirt -f kubevirt
kubectl -n kubevirt wait kv kubevirt --for condition=Available --timeout="600s"
