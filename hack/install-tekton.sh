kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
kubectl get svc,deploy --namespace tekton-pipelines --selector=app.kubernetes.io/part-of=tekton-pipelines

kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml
kubectl get svc,deploy -n tekton-pipelines --selector=app=tekton-dashboard


export url="https://github.com/tektoncd/cli/releases/download/v0.17.0/tkn_0.17.0_Linux_x86_64.tar.gz"
curl -L $url | tar xzvf - --directory $(pwd)/bin tkn
chmod +x $(pwd)/bin/*
