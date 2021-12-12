#!/bin/bash
#
# Initial configuration of the kube host

IP_HOST="$(ip addr show enp1s0 | grep 'inet ' | cut -d ' ' -f 6 | cut -d '/' -f1)"
IP_RANGE_HOST="$(echo ${IP_HOST} | rev | cut -d '.' -f 2- | rev).0/24"

if [ -b /dev/sdb ] ; then
    echo "/dev/vdb    /storage    xfs     defaults    1 2" >> /etc/fstab
    echo "/dev/vdc    /data       ext4    defaults    1 2" >> /etc/fstab

    mkdir /storage
    mount /storage
    mkdir /data
    mount /data
fi

chmod -x /etc/update-motd.d/10-help-text
echo """#!/bin/sh
echo
df -h | grep dev| egrep -v "loop|tmpfs|udev" | sed 's:^:  :g'""" > /etc/update-motd.d/50-landscape-sysinfo-addon
chmod a+x /etc/update-motd.d/50-landscape-sysinfo-addon

echo "cd /data/repo/docker" >> /home/tuner/.bashrc
echo "source <(kubectl completion bash)" >> /home/tuner/.bashrc
sed -i 's:HISTSIZE=.*:HISTSIZE=10000:g' /home/tuner/.bashrc
sed -i 's:HISTFILESIZE=.*:HISTFILESIZE=100000:g' /home/tuner/.bashrc
echo "ulimit -n 65536" >> /home/tuner/.bashrc

echo "alias kubectl='microk8s.kubectl'" >>  /home/tuner/.bash_aliases
echo "alias helm='microk8s.helm3'" >>  /home/tuner/.bash_aliases
echo "alias helm3='microk8s.helm3'" >>  /home/tuner/.bash_aliases
echo "alias kubectl='microk8s.kubectl'" >>  /root/.bash_aliases
chown tuner /home/tuner/.bash_aliases

echo "net.ipv4.tcp_keepalive_time = 86400" >> /etc/sysctl.conf

echo """LANGUAGE=en_US.UTF-8
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8""" > /etc/default/locale
locale-gen en_US.UTF-8

usermod -a -G microk8s tuner
mkdir /home/tuner/.kube
chown -f -R tuner /home/tuner/.kube

echo """set hlsearch
set expandtab
colorscheme lucius
set tabstop=4
set encoding=utf-8
set fileencoding=utf-8""" > /home/tuner/.vimrc

apt-get update
apt-get upgrade
apt-get disl-upgrade
apt install apt-file
apt-file update

echo "${IP_HOST} kube kube.host" >> /etc/hosts

echo """[Unit]
Description=Ultimate Target
Requires=multi-user.target
After=multi-user.target
AllowIsolate=yes""" > /etc/systemd/system/ultimate.target

echo """[Unit]
Description=rc.local
After=multi-user.target

[Service]
Type=simple
ExecStart=/data/repo/docker/bin/rc_local.sh
ExecStop=/snap/bin/microk8s.stop

[Install]
WantedBy=ultimate.target""" > /etc/systemd/system/rc_local.service

mkdir /etc/systemd/system/ultimate.target.wants
ln -s /etc/systemd/system/rc_local.service /etc/systemd/system/ultimate.target.wants/rc_local.service
systemctl daemon-reload
systemctl set-default ultimate.target
systemctl isolate ultimate.target
systemctl enable rc_local.service

mkdir /storage/k8s
sed -i 's:--root ${SNAP_COMMON}/var/lib/containerd:--root /storage/k8s/containerd:g' /var/snap/microk8s/current/args/containerd
sed -i 's:--state ${SNAP_COMMON}/run/containerd:--state /storage/k8s/run:g' /var/snap/microk8s/current/args/containerd

echo 'CHANGE: # "\e[5~": history-search-backward in /etc/inputrc'
echo 'reboot naw'

# --------- after reboot ------------------------
sudo rm -r /var/snap/microk8s/common/var/lib/containerd/
microk8s.enable dashboard dns helm3 metrics-server registry

