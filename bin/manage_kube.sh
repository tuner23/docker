#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
#WORKDIR="${SCRIPTPATH}/../charts"
#CMDS="install upgrade delete purge"
#FORCE=""
#DRY=""

usage() { 
    echo -e "Usage:\n$0 [start|stop|url|service|login]"
    echo -e "Options:"
    echo -e "\tinit: \t\t\tSetup minikube with helm and tiller (first start kube)"
    echo -e "\tstart: \t\t\tStart minikube"
    echo -e "\tstop: \t\t\tStop minikube"
    echo -e "\turl: \t\t\tGet dashboard url"
    echo -e "\tdocker: \t\tSet docker env"
    echo -e "\tservice [SERVICENAME]: \tGet service url"
    echo -e "\tlogin [SERVICENAME]: \tPrint docker login command"
#    echo -e "\t--debug\t\trun in debug mode"
}

if [ "$#" -lt 1 ] ; then
{
  usage
  exit 1
}
fi

CMD="$1"
if [ "$#" -gt 1 ] ; then
{
    OPT="${@:2}"
}
fi

error_exit() {
    echo -e "Error: $1"
	exit 1
}

#check_args() {
#    ## chart
#    if [ ! -d "${WORKDIR}/${CHART}" ] ; then
#	    error_exit "Chart dir not found: ${WORKDIR}/${CHART}"
#	fi
#    if [[ "${CMDS}" != *${CMD}* ]] ; then
#        error_exit "Command ${CMD} is not one of ${CMDS// /$','}"
#    fi
#}

init_kube() {
    #rm -r ~/.minikube/*
    #rm /etc/libvirt/qemu/minikube.xml
    minikube addons enable heapster
    minikube addons enable metrics-server
    minikube addons enable logviewer

    cd "${SCRIPTPATH}"
    rm -r /home/tuner/.helm/*
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh
    kubectl create serviceaccount -n kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    helm init --service-account tiller --history-max 200
    helm repo update
}

start_kube() {
    minikube start --mount -v 10 --memory 6144 --cpus 2 --mount-string="/data/vms/storage/minikube:/volumes" --vm-driver=kvm2 &
}

stop_kube() {
    minikube stop
}

get_url() {
    minikube dashboard --url &
}

docker_env() {
    /usr/bin/minikube docker-env | grep export | \
    while read line ; do
    {
        echo $line
        #source <(echo "$line");
    }
    done
}

get_service_url() {
    minikube --namespace=development service $OPT --url
}

login_container() {
    echo "docker exec -ti $(docker ps -a | grep tuner/$OPT | awk '{ print $1 }' | head -n 1) /bin/bash"
}

case "${CMD}" in
    init)
        init_kube
        ;;
    start)
        start_kube
        ;;
    stop)
        stop_kube
        ;;
    url)
        get_url
        ;;
    docker)
        docker_env
        ;;
    service)
        get_service_url $OPT
        ;;
    login)
        login_container $OPT
        ;;
    *)
        error_exit "Could not find command: $CMD ?"
        ;;
esac
