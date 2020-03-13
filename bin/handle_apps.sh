#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
kubectl='microk8s.kubectl'
#WORKDIR="${SCRIPTPATH}/../charts"
#CMDS="install upgrade delete purge"
#FORCE=""
#DRY=""

usage() { 
    echo -e "Usage:\n$0 [service|login]"
    echo -e "Options:"
    echo -e "\tservices [SERVICENAME]: \tGet services"
    echo -e "\tpods [SERVICENAME]: \tGet pods"
    echo -e "\tlogin [SERVICENAME]: \tlogin to container"
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

get_services() {
    echo "NAME         TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE"
    echo "-- mg -------"
    $kubectl get services --namespace=mg | grep -v "CLUSTER-IP"
    echo "-- devel ----"
    $kubectl get services --namespace=development | grep -v "CLUSTER-IP"
}

get_pods() {
    echo "NAME           READY   STATUS    RESTARTS   AGE"
    echo "-- mg -------"
    $kubectl get pods --namespace=mg | grep -v "READY"
    echo "-- devel ----"
    $kubectl get pods --namespace=development | grep -v "READY"
}


login_container() {
    echo ${OPT}
    if [[ "${OPT}" =~ ^app-.* ]] ; then
        NS="mg"
    else
        NS="development"
    fi
    $kubectl exec ${OPT}-0 --namespace=${NS}  -it -- /bin/bash
}

case "${CMD}" in
    services)
        get_services $OPT
        ;;
    pods)
        get_pods $OPT
        ;;
    login)
        login_container $OPT
        ;;
    *)
        error_exit "Could not find command: $CMD ?"
        ;;
esac
