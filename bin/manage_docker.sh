#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
WORKDIR="${SCRIPTPATH}/../charts"
CMDS="test jenkins"
BUILD=""
PRIV_PACKS="x11-libs/libX11 dev-libs/gobject-introspection x11-libs/gdk-pixbuf"i

usage() { 
    echo -e "Usage:\n$0 [test|jenkins] [CONTAINER] [--build]"
    echo -e "\ttest: create a test container"
    echo -e "\tjenkins: Build ptrace packages local and push to dockerhub (with --privileged for Jenkins)"
    echo -e "Options:"
    echo -e "\t--build\tbuild base image, else use existing.."
    echo
}

if [ "$#" -lt 1 ] ; then
{
  usage
  exit 1
}
fi

CMD="$1"
CONTAINER="$2"
OPT="${@:3}"

if [[ "${OPT}" == *--build* ]] ; then
    BUILD="--build"
fi

error_exit() {
    echo -e "Error: $1"
	exit 1
}

check_args() {
    if [[ "${CMDS}" != *${CMD}* ]] ; then
        error_exit "Argument ${CMD} is not one of ${CMDS// /$','}"
    fi
}

start_container() {
    eval $(minikube docker-env)
    cd "${WORKDIR}"

    echo "Removing old stuff.."
    docker rm $(docker ps -a | egrep " ${CONTAINER}-skel" | cut -d ' ' -f1)
    docker rmi $(docker images | egrep "^${CONTAINER}-skel" | awk '{ print $3 }')

    echo -n "Building container.."
    if [ "$BUILD" == "--build" ] ; then
        echo " from scratch.." 
        if [ "${CONTAINER}" != "jenkins" ] ; then
            docker build -t ${CONTAINER}-skel --file ./${CONTAINER}/docker/${CONTAINER}/skel/Dockerfile.testing .
        else
            echo -e "FROM gentoo/portage:latest as portage\nFROM tuner/gentoo-skel:latest\nCOPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo"  | docker build -t ${CONTAINER}-skel-local -
            docker run --privileged -ti --name ${CONTAINER}-skel ${CONTAINER}-skel-local:latest /bin/bash -c "emerge -D1 ${PRIV_PACKS}"
            docker commit ${CONTAINER}-skel ${CONTAINER}-skel-local
            docker rm ${CONTAINER}-skel
            docker build -t ${CONTAINER}-skel --file ./${CONTAINER}/docker/${CONTAINER}/skel/Dockerfile.testing .
        fi
    else
        echo " from dockerhub image.."
        echo -e "FROM gentoo/portage:latest as portage\nFROM tuner/${CONTAINER}-skel:latest\nCOPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo"  | docker build -t ${CONTAINER}-skel -
    fi
    
    echo "Starting ${CONTAINER} container  ..."
    docker run -ti --name ${CONTAINER}-skel:latest ${CONTAINER}-skel /bin/bash
}

build_jenkins() {
    CONTAINER="jenkins"
    eval $(minikube docker-env)
    cd "${WORKDIR}"

    echo "Removing old stuff.."
    (docker rm $(docker ps -a | egrep " ${CONTAINER}-skel-local" | cut -d ' ' -f1) || true)
    (docker rmi $(docker images | egrep "^${CONTAINER}-skel-local" | awk '{ print $3 }') || true)

    echo -n "Building container.."
    echo -e "FROM gentoo/portage:latest as portage\nFROM tuner/gentoo-skel:latest\nCOPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo"  | docker build -t ${CONTAINER}-skel-local -
    docker run --privileged -ti --name ${CONTAINER}-skel-local ${CONTAINER}-skel-local:latest /bin/bash -c "emerge -D1 ${PRIV_PACKS} && rm -rf /var/db/repos/gentoo && rm -rf /var/cache/distfiles/*"
    docker commit ${CONTAINER}-skel-local tuner/gentoo-jenkins
    docker login
    docker push tuner/gentoo-jenkins
}

## main ##
check_args

case "${CMD}" in
    test)
        start_container
        ;;
    jenkins)
        build_jenkins
        ;;
    *)
        error_exit "Could not find command ?"
        ;;
esac
