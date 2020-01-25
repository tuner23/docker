#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
#WORKDIR="${SCRIPTPATH}/../charts"
#CMDS="install upgrade delete purge"
#FORCE=""
#DRY=""

usage() { 
    echo -e "Usage:\n$0 [start|stop|url]"
    echo -e "Options:"
    echo -e "\tstart: \t\t\tStart minikube"
    echo -e "\tstop: \t\t\tStop minikube"
    echo -e "\turl: \t\t\tGet dashboard url"
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

start_kube() {
    microk8s.start
}

stop_kube() {
    microk8s.stop
}

get_url() {
    microk8s.kubectl port-forward --address 0.0.0.0 -n kube-system service/kubernetes-dashboard 10443:443 &
    
    token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
    microk8s.kubectl -n kube-system describe secret $token

    echo "DASHBOARD URL: https://kube:10443/"
}

case "${CMD}" in
    start)
        start_kube
        ;;
    stop)
        stop_kube
        ;;
    url)
        get_url
        ;;
    *)
        error_exit "Could not find command: $CMD ?"
        ;;
esac
