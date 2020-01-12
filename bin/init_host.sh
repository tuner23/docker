#!/bin/bash
#
# Initial configuration of the host


IP_HOST="$(ip addr show enp1s0 | grep 'inet ' | cut -d ' ' -f 6 | cut -d '/' -f1)"
IP_RANGE_HOST="$(echo ${IP_HOST} | rev | cut -d '.' -f 2- | rev).0/24"
IP_RANGE_DOCKER="10.1.0.0/16"

if [ -b /dev/sdb ] ; then
    #mkfs.ext4 /dev/vdb
    echo "/dev/vdb                /storage          ext4    defaults        1 2" >> /etc/fstab

    mkdir /storage
    mount /storage
fi

echo "alias kubectl='microk8s.kubectl'" >  /home/tuner/.bash_aliases
echo "alias helm='microk8s.helm'" >  /home/tuner/.bash_aliases
echo "alias kubectl='microk8s.kubectl'" >  /root/.bash_aliases
chown tuner /home/tuner/.bash_aliases

apt-get update
apt-get upgrade

echo "${IP_HOST} kube kube.host" >> /etc/hosts

#---- tuner --------------------
su - tuner
microk8s.stop
mkdir /storage/_kube/
mv /var/snap/microk8s/common/var/lib/* /storage/_kube/
/bin/sed -i.bak 's:--root ${SNAP_COMMON}/var/lib/containerd:--root /storage/_kube/containerd:g' /var/snap/microk8s/1107/args/containerd
/bin/sed -i.bak 's:--root-dir=${SNAP_COMMON}/var/lib/kubelet:--root-dir=/storage/_kube/kubelet:g' /var/snap/microk8s/1107/args/kubelet
mv /var/snap/microk8s/common/run/containerd/ /storage/_kube/run
/bin/sed -i.bak 's:--state ${SNAP_COMMON}/run/containerd:s:--state /storage/_kube/run' /var/snap/microk8s/current/args/containerd

microk8s.start

microk8s.enable dns dashboard helm metrics-server ingress

#microk8s.enable registry
#helm repo update
exit


#TODO
