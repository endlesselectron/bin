#!/bin/sh

while [ ${#} -gt 1 ]
do
    case ${1} in
        --project-name)
            PROJECT_NAME=${2} &&
            shift &&
            shift &&
            true
        ;;
        --email)
            EMAIL=${2} &&
            shift &&
            shift &&
            true
        ;;
        --name)
            NAME=${2} &&
            shift &&
            shift &&
            true
        ;;
        --upstream)
            UPSTREAM=${2} &&
            shift &&
            shift &&
            true
        ;;
        --origin)
            ORIGIN=${2} &&
            shift &&
            shift &&
            true
        ;;
        --parent)
            PARENT=${2} &&
            shift &&
            shift &&
            true
        ;;
    esac &&
    true
done &&
    WORKSPACE_VOLUME=$(docker volume create) &&
    INIT_VOLUME=$(docker volume create) &&
    BIN_VOLUME=$(docker volume create) &&
    PROJECT_VOLUME=$(docker volume create) &&
    (cat <<EOF
#!/bin/sh

docker \
       run \
       --interactive \
       --tty \
       --detach \
       --cidfile /root/cid \
       --volume ${WORKSPACE_VOLUME}:/workspace/${PROJECT_NAME} \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       --privileged \
       --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
       --net host \
       --workdir /workspace/${PROJECT_NAME} \
       --env DISPLAY \
       --volume /home/vagrant/.ssh:/root/.ssh:ro \
       --volume /home/vagrant/bin:/root/bin:ro \
       --volume /home/vagrant/.bash_profile:/root/.bash_profile:ro \
       --volume ${PROJECT_VOLUME}:/init \
       emorymerryman/strongarm:0.1.3 \
       &&
       echo \${HOME}/bin/shell.sh >> /etc/shells &&
       chsh --shell \${HOME}/bin/shell.sh &&
       true
EOF
    ) | volume-tee.sh ${INIT_VOLUME} init.sh &&
    (cat <<EOF
#!/bin/sh

docker exec --interactive --tty \$(cat /root/cid) env CONTAINER_ID=\$(cat /root/cid) bash --login &&
       true
EOF
    ) | volume-tee.sh ${BIN_VOLUME} shell.sh &&
    docker run --interactive --tty --rm --volume ${BIN_VOLUME}:/usr/local/src alpine:3.4 chmod 0500 /usr/local/src/shell.sh &&
    (cat <<EOF
#!/bin/sh

git -C /workspace/${PROJECT_NAME} init &&
    ln --symbolic --force /root/bin/post-commit.sh /workspace/${PROJECT_NAME}/.git/hooks/post-commit &&
    ( [ -z "${EMAIL}" ] || git -C /workspace/${PROJECT_NAME} config user.email "${EMAIL}" ) &&
    ( [ -z "${NAME}" ] || git -C /workspace/${PROJECT_NAME} config user.name "${NAME}" ) &&
    ( [ -z "${UPSTREAM}" ] || git -C /workspace/${PROJECT_NAME} remote add upstream ${UPSTREAM} ) &&
    ( [ -z "${ORIGIN}" ] || git -C /workspace/${PROJECT_NAME} remote add origin ${ORIGIN} ) &&
    ( [ -z "${PARENT}" ] || git -C /workspace/${PROJECT_NAME} fetch upstream ${PARENT} && git -C /workspace/${PROJECT_NAME} checkout upstream/${PARENT}  ) &&
    git -C /workspace/${PROJECT_NAME} checkout -b scratch/$(uuidgen) &&
    true
EOF
    ) | volume-tee.sh ${PROJECT_VOLUME} init.sh &&
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
