#!/bin/bash

CONTEXT="--context kind-artemis"

kubectl ${CONTEXT} apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

kubectl ${CONTEXT} create sa k8sdash -n kube-system
kubectl ${CONTEXT} create clusterrolebinding k8sdash-crb --clusterrole=cluster-admin --serviceaccount=kube-system:k8sdash

kubectl ${CONTEXT} -n kube-system describe secret $(kubectl -n kube-system get secret | grep k8sdash | awk '{print $1}')