#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
WORKDIR="${SCRIPTPATH}/../charts"
CMDS="install upgrade delete purge"
FORCE=false
DRY=false

usage() { 
    echo -e "Usage:\n$0 [CHART_NAME] [install|upgrade|delete|purge] [--dry-run|--debug]"
}

if [ "$#" -lt 2 ] ; then
{
  usage
  exit 1
}
fi

CHART="$1"
CMD="$2"
OPT="${@:3}"

if [[ "${OPT}" = *--dry-run* ]] ; then
    DRY="--dry-run"
fi

if [[ "${OPT}" = *--debug* ]] ; then
    DEBUG="--debug"
fi

error_exit() {
    echo -e "Error: $1"
	exit 1
}

check_args() {
    ## chart
    if [ ! -d "${WORKDIR}/${CHART}" ] ; then
	    error_exit "Chart dir not found: ${WORKDIR}/${CHART}"
	fi
    if [[ "${CMDS}" != *${CMD}* ]] ; then
        error_exit "Command ${CMD} is not one of ${CMDS// /$','}"
    fi
}

install_chart() {
    cd "${WORKDIR}"
    echo "Installing $CHART with options $DRY ..."
    helm install $DRY $DEBUG --name $CHART ./$CHART/
}

upgrade_chart() {
    cd "${WORKDIR}"
    echo "Upgrading $CHART with options $DRY ..."
    helm upgrade $DRY $DEBUG $CHART $CHART
}

delete_chart() {
    echo "Deleting $CHART with options $DRY ..."
    helm delete --purge $DRY $DEBUG $CHART
}

get_args "$@"
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
        delete_chart
        ;;
    *)
        error_exit "Could not find command ?"
        ;;
esac
