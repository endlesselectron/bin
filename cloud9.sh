#!/bin/sh

TEMP_INIT=$(mktemp -d) &&
    TEMP_BIN=$(mktemp -d) &&
    WORKSPACE_VOLUME=$(docker volume create) &&
    INIT_VOLUME=$(docker volume create) &&
    BIN_VOLUME=$(docker volume create) &&
    (cat > ${TEMP_INIT}/init.sh <<EOF
#!/bin/sh

docker \
       run \
       --interactive \
       --tty \
       --detach \
       --cidfile /root/cid \
       --volume ${WORKSPACE_VOLUME}:/workspace \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       --privileged \
       --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
       --net host \
       --workdir /workspace \
       --env DISPLAY \
       emorymerryman/strongarm:0.0.7 \
       sh \
       &&
       echo \${HOME}/bin/shell.sh >> /etc/shells &&
       chsh --shell \${HOME}/bin/shell.sh &&
       true
EOF
    ) &&
    (cat > ${TEMP_BIN}/shell.sh <<EOF
#!/bin/sh

docker exec --interactive --tty \$(cat /root/cid) sh &&
       true
EOF
    ) &&
    chmod 0500 ${TEMP_BIN}/shell.sh &&
    docker run --interactive --tty --rm --volume ${TEMP_INIT}:/input:ro --volume ${INIT_VOLUME}:/output alpine:3.4 cp --recursive /input/. /output &&
    docker run --interactive --tty --rm --volume ${TEMP_BIN}:/input:ro --volume ${BIN_VOLUME}:/output alpine:3.4 cp --recursive /input/. /output &&
    docker \
	run \
	--volume ${BIN_VOLUME}:/root/bin:ro \
	--interactive \
	--tty \
	--detach \
	--volume /var/run/docker.sock:/var/run/docker.sock:ro \
	--privileged \
	--volume ${WORKSPACE_VOLUME}:/workspace \
	--expose 8181 \
	--publish-all \
	--volume ${INIT_VOLUME}:/init:ro \
	--env DISPLAY \
	emorymerryman/cloud9:4.0.7 \
	--listen 0.0.0.0 \
	--auth user:password \
	-w /workspace \
	&&
	docker ps --latest &&
	true
