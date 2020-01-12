#!/bin/bash

# Setup the system
IP_HOST="$(ip addr show enp1s0 | grep 'inet ' | cut -d ' ' -f 6 | cut -d '/' -f1)"
IP_RANGE_HOST="$(echo ${IP_HOST} | rev | cut -d '.' -f 2- | rev).0/24"
IP_RANGE_DOCKER="10.1.0.0/16"

microk8s.kubectl port-forward --address 0.0.0.0 -n kube-system service/kubernetes-dashboard 10443:443 &

token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s.kubectl -n kube-system describe secret $token

echo "DASHBOARD URL: https://kube:10443/"

#TODO
