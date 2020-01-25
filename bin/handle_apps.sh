#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
#WORKDIR="${SCRIPTPATH}/../charts"
#CMDS="install upgrade delete purge"
#FORCE=""
#DRY=""

usage() { 
    echo -e "Usage:\n$0 [service|login]"
    echo -e "Options:"
    echo -e "\tservice [SERVICENAME]: \tGet service url"
    echo -e "\tlogin [SERVICENAME]: \tPrint docker login command"
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

get_service_url() {
    minikube --namespace=development service $OPT --url
}

login_container() {
    
}

case "${CMD}" in
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
