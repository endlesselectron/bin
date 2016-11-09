#!/bin/sh

docker \
    run \
    --interactive \
    --tty \
    --detach \
    --privileged \
    --net host \
    --env DISPLAY \
    --volume /tmp/.X11 \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume ${HOME}/.ssh:/root/.ssh \
    --volume ${HOME}/bin:/root/bin \
    emorymerryman/strongarm:0.0.2 &&
    docker \
    run \
    --interactive \
    --tty \
    --detach \
    --env PROJECT_NAME="${1}" \
    --env PROJECT_COMMAND="docker exec --interactive --tty $(docker ps -q --latest) bash" \
    --volume $(docker inspect --format '{{ range .Mounts }}{{ if eq .Destination "/usr/local/src" }}{{ .Name }}{{ end }}{{ end }}' $(docker ps -q --latest)
e5f723543f374d5dfd0d1e0890eb894394f40e8131f10c074ebf0a2bdd6dd045):/usr/local/src/${1} \
    --privileged \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --publish-all \
    emorymerryman/cloud9:3.0.0 &&
    docker ps --latest &&
    true