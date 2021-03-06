#!/bin/sh

PROJECT_NAME=strongarm &&
    PROJECT_INIT=$(mktemp -d) &&
    TEMP_INIT=$(mktemp -d) &&
    TEMP_BIN=$(mktemp -d) &&
    PROJECT_VOLUME=$(docker volume create) &&
    WORKSPACE_VOLUME=$(docker volume create) &&
    INIT_VOLUME=$(docker volume create) &&
    BIN_VOLUME=$(docker volume create) &&
    (cat > ${PROJECT_INIT}/init.sh <<EOF
#!/bin/sh

git -C /workspace/${PROJECT_NAME} init &&
    git -C /workspace/${PROJECT_NAME} remote add upstream git@github.com:tidyrailroad/strongarm.git &&
    git -C /workspace/${PROJECT_NAME} remote add origin git@github.com:tidyrailroad/strongarm.git &&
    git -C /workspace/${PROJECT_NAME} fetch upstream develop &&
    git -C /workspace/${PROJECT_NAME} checkout upstream/develop &&
    ln --symbolic --force /root/bin/post-commit.sh /workspace/${PROJECT_NAME} &&
    true
EOF
    ) &&
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
       --workdir /workspace/${PROJECT_NAME} \
       --env DISPLAY \
       --volume /home/vagrant/.ssh:/root/.ssh:ro \
       --volume /home/vagrant/bin:/root/bin:ro \
       --volume /home/vagrant/.bash_profile:/root/.bash_profile:ro \
       --volume ${PROJECT_VOLUME}:/init:ro \
       --env GIT_EMAIL="emory.merryman@gmail.com" \
       --env GIT_NAME="Emory Merryman" \
       emorymerryman/strongarm:0.1.2 \
       &&
       echo \${HOME}/bin/shell.sh >> /etc/shells &&
       chsh --shell \${HOME}/bin/shell.sh &&
       true
EOF
    ) &&
    (cat > ${TEMP_BIN}/shell.sh <<EOF
#!/bin/sh

docker exec --interactive --tty \$(cat /root/cid) bash --login &&
       true
EOF
    ) &&
    chmod 0500 ${TEMP_BIN}/shell.sh &&
    echo docker run --interactive --tty --rm --volume ${PROJECT_INIT}:/input:ro --volume ${PROJECT_VOLUME}:/output alpine:3.4 cp --recursive /input/. /output &&
    docker run --interactive --tty --rm --volume ${PROJECT_INIT}:/input:ro --volume ${PROJECT_VOLUME}:/output alpine:3.4 cp --recursive /input/. /output &&
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
	--volume ${WORKSPACE_VOLUME}:/workspace/${PROJECT_NAME} \
	--expose 8181 \
	--publish-all \
	--volume ${INIT_VOLUME}:/init:ro \
	--env DISPLAY \
	emorymerryman/cloud9:4.0.7 \
	--listen 0.0.0.0 \
	--auth user:password \
	-w /workspace/${PROJECT_NAME} \
	&&
	docker ps --latest &&
	true
