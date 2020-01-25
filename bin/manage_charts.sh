#!/bin/bash

helm='/snap/bin/microk8s.helm'
kubectl='/snap/bin/microk8s.kubectl'

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
WORKDIR="${SCRIPTPATH}/../charts"
CMDS="install upgrade delete purge"
FORCE=""
DRY=""

usage() { 
    echo -e "Usage:\n$0 [install|upgrade|delete|purge] [CHART_NAME|all] [--dry-run|--debug]"
    echo -e "Options:"
    echo -e "\t--dry-run\tdon't change"
    echo -e "\t--debug\t\trun in debug mode"
    echo
}

if [ "$#" -lt 2 ] ; then
{
  usage
  exit 1
}
fi

CMD="$1"
CHART="$2"
OPT="${@:3}"

if [[ "${OPT}" == *--dry-run* ]] ; then
    DRY="--dry-run"
fi

if [[ "${OPT}" == *--debug* ]] ; then
    DEBUG="--debug"
fi

error_exit() {
    echo -e "Error: $1"
	exit 1
}

check_args() {
    if [[ "${CMDS}" != *${CMD}* ]] ; then
        error_exit "Argument ${CMD} is not one of ${CMDS// /$','}"
    fi
    if [ "$CHART" != "all" ] ; then
        if [ ! -d "${WORKDIR}/${CHART}" ] ; then
    	    error_exit "Chart dir not found: ${WORKDIR}/${CHART}"
    	fi
    fi
}

install_chart() {
    cd "${WORKDIR}"
    if [ "$CHART" == "all" ] ; then
        do_all
    else
        echo "Installing $CHART with options $DRY ..."
        $helm install $DRY $DEBUG --name $CHART ./$CHART/
    fi
}

do_all() {
    if [ "$CMD" == "install" ] ; then
        $helm install $DRY $DEBUG --name common ./common/
        $helm install $DRY $DEBUG --name git ./git/
        $helm install $DRY $DEBUG --name devel ./devel/
        $helm install $DRY $DEBUG --name jenkins ./jenkins/
    elif [ "$CMD" == "delete" ] ; then
        $helm delete $DRY $DEBUG --name jenkins
        $helm delete $DRY $DEBUG --name devel
        $helm delete $DRY $DEBUG --name git
        $helm delete $DRY $DEBUG --name common
    fi
}

upgrade_chart() {
    cd "${WORKDIR}"
    echo "Upgrading $CHART with options $DRY ..."
    $helm upgrade $DRY $DEBUG $CHART $CHART
}

delete_chart() {
    echo "Deleting $CHART with options $DRY ..."
    $helm delete --purge $DRY $DEBUG $CHART
}

purge_chart() {
    echo "Purging $CHART with options $DRY ..."
    $helm delete --purge $DRY $DEBUG $CHART

    $kubectl delete service ${CHART}
    $kubectl delete pvc ${CHART}-pvc
    $kubectl delete pv ${CHART}-pv
    $kubectl delete deployment ${CHART}
    $kubectl delete configmap ${CHART}-configmap
    $kubectl delete pod ${CHART}
}

check_args

case "${CMD}" in
    install)
        install_chart
        ;;
    upgrade)
        upgrade_chart
        ;;
    delete)
        delete_chart
        ;;
    purge)
        purge_chart
        ;;
    all)
        do_all
        ;;
    *)
        error_exit "Could not find command ?"
        ;;
esac
