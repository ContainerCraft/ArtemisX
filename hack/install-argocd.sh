################################################################################
kubectl apply -f artemis.yml

################################################################################
#echo "---" >> artemis.yml
#kubectl patch deployment -n argocd argocd-server --patch "$(cat ../patch/argocd-server-patch.yaml)"
#curl -sSL -o $(pwd)/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
#chmod +x $(pwd)/bin/*
#kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
