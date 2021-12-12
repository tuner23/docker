#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
kubectl='microk8s.kubectl'
helm3='microk8s.helm3'
#WORKDIR="${SCRIPTPATH}/../charts"
#CMDS="install upgrade delete purge"
#FORCE=""
#DRY=""

usage() { 
    echo -e "Usage:\n$0 OPTION [PARAMETER]"
    echo -e "Options:"
    echo -e "\tnamespaces: \t\t\tGet namespaces"
    echo -e "\tdeployments: \t\t\tGet deployments"
    echo -e "\tservices [all|NAMESPACE]: \tGet services"
    echo -e "\tpods [all|NAMESPACE]: \t\tGet pods"
    echo -e "\tlogin [SERVICENAME]: \t\tLogin to container"
    echo -e "\tlogs [SERVICENAME]: \t\tLogs from container"
    echo -e "\trestart [POD]: \t\t\tRestart a pod"
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
    if [ -z "${OPT}" ] ; then
        echo "NAME         TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE"
        echo "-- mg -------"
        $kubectl get services --namespace=mg | grep -v "CLUSTER-IP"
        echo "-- devel ----"
        $kubectl get services --namespace=development | grep -v "CLUSTER-IP"
    elif [ "${OPT}" == 'all' ] ; then
        $kubectl get services --all-namespaces
    else
        $kubectl get services --namespace ${OPT}
    fi
}

get_pods() {
    if [ -z "${OPT}" ] ; then
        echo "NAME           READY   STATUS    RESTARTS   AGE"
        echo "-- mg -------"
        $kubectl get pods --namespace=mg | grep -v "READY"
        echo "-- devel ----"
        $kubectl get pods --namespace=development | grep -v "READY"
    elif [ "${OPT}" == 'all' ] ; then
        $kubectl get pods --all-namespaces
    else
        $kubectl get pods -n ${OPT}
    fi
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

logs_container() {
    echo ${OPT}
    if [[ "${OPT}" =~ ^app-.* ]] ; then
        NS="mg"
    else
        NS="development"
    fi
    echo "Init-Container logs"
    echo "--------------------------------"
    $kubectl logs ${OPT}-0 --namespace=${NS} -c init-${OPT}
    echo "Container logs"
    echo "--------------------------------"
    $kubectl logs ${OPT}-0 --namespace=${NS}
}

restart_pod() {
    if [ -z $OPT ] ; then echo "Sorry, please pass a pod!" ; exit ; fi
    IFS_BACK=$IFS
    IFS=$'\n'
    pods=$(${kubectl} get pods --all-namespaces)
    for pod in ${pods} ; do
        if [[ ${pod} == *${OPT}* ]]; then
            NS=$(echo ${pod} | cut -d ' ' -f1)
            break
        fi
    done
    IFS=$IFS_BACK
    
    $kubectl scale deployment ${OPT} --replicas=0 -n ${NS}
    sleep 5
    $kubectl scale deployment ${OPT} --replicas=1 -n ${NS}
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
    logs)
        logs_container $OPT
        ;;
    deployments)
        $helm3 list
        ;;
    namespaces)
        $kubectl get ns
        ;;
    restart)
        restart_pod $OPT
        ;;
    *)
        error_exit "Could not find command: $CMD ?"
        ;;
esac
