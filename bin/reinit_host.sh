#!/bin/bash
#

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

usage() {
    echo -e "Cleanup microk8s on failures"
    echo -e "Usage:\n$0 [clean|purge]"
    echo -e "Options:"
    echo -e "\tclean: \t\t\tCleanup microk8s installation"
    echo -e "\tpurge: \t\t\tComplete purge and reinstall microk8s"
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

cleanup_system() {
    microk8s stop
    sudo find /storage/k8s/run/ -maxdepth 1 -iname '*containerd*' -exec rm -r {} \;
}

purge_system() {
    echo "---- NOT IMPLEMENTED YET! ------------------------------"
    
    # Purge and rerun
    echo """microk8s stop
    snap list
    sudo snap remove microk8s lxd
    snap list
    sudo systemctl stop snapd
    sudo apt remove --purge --assume-yes snapd gnome-software-plugin-snap
    
    rm -rf ~/snap/
    sudo rm -rf /var/cache/snapd/
    rm -r /home/tuner/.kube/*
    sudo rm -rf /storage/*
    
    sudo reboot
    
    usermod -a -G microk8s tuner
    mkdir /home/tuner/.kube
    chown -f -R tuner /home/tuner/.kube
    
    sudo mkdir /storage/k8s
    sudo chown -R root:microk8s /storage/
    
    sudo apt install snapd gnome-software-plugin-snap
    snap info microk8s
    sudo snap install microk8s --classic --channel=1.XX/stable
    kubectl get pods -n kube-system
    microk8s.stop
    
    sed -i 's:--root ${SNAP_COMMON}/var/lib/containerd:--root /storage/k8s/containerd:g' /var/snap/microk8s/current/args/containerd
    sed -i 's:--state ${SNAP_COMMON}/run/containerd:--state /storage/k8s/run:g' /var/snap/microk8s/current/args/containerd
    
    cat /var/snap/microk8s/current/args/containerd
    microk8s.start
    
    kubectl get pods -n kube-system
    microk8s.enable dashboard dns helm3 metrics-server"""

    echo "---- NOT IMPLEMENTED YET! ------------------------------"
}

error_exit() {
    echo -e "Error: $1"
    exit 1
}

case "${CMD}" in
    clean)
        cleanup_system $OPT
        ;;
    purge)
        purge_system $OPT
        ;;
    *)
        error_exit "Could not find command: $CMD ?"
        ;;
esac
