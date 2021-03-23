sudo podman run --privileged \
    --tty --detach --net kind \
    --tmpfs /run --tmpfs /tmp \
    --name artemis-control-plane \
    --publish=127.0.0.1:80:80/tcp \
    --publish=127.0.0.1:443:443/tcp \
    --hostname artemis-control-plane \
    --publish=127.0.0.1:8080:8080/tcp \
    --publish=127.0.0.1:5000:5000/tcp \
    --publish=127.0.0.1:2222:2222/tcp \
    --publish=127.0.0.1:9097:9097/tcp \
    --publish=127.0.0.1:6443:6443/tcp \
    --volume /lib/modules:/lib/modules:ro \
    --label io.x-k8s.kind.cluster=artemis \
    --label io.x-k8s.kind.role=control-plane \
    --volume 4f803411fac0599215e63c444ee65cc0a56c174fe71d9b65698481d4819d55e2:/var:suid,exec,dev \
  kindest/node@sha256:8f7ea6e7642c0da54f04a7ee10431549c0257315b3a634f6ef2fecaaedb19bab
