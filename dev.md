```sh
helm install calypso ccio/calypso --namespace rook-ceph --create-namespace
helm install artemis ccio/artemis --namespace artemis --create-namespace --wait=false --no-hooks
helm install cluster-network-addons ccio/cluster-network-addons --namespace cluster-network-addons --create-namespace
helm install kargo ccio/kargo --namespace kargo --create-namespace
```
