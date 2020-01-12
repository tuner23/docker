# microk8s
## default locations
> SNAP_DATA="/var/snap/microk8s/current/"
> SNAP_COMMON="/var/snap/microk8s/common/"

## kubernetes service locations
### api-server
* validate and configure data for pods, services, replication controllers, etc..
> API="${SNAP_DATA}/args/kube-apiserver"
### containerd
* manage images and execute containers
> CONTAINERD="a${SNAP_DATA}/rgs/containerd"
### controller-manager
* watch the shared state and make changes to move the current state to the desired state
> CONTROLLER="${SNAP_DATA}/args/kube-controller-manager"
### etcd
* key/value datastore used to support the components
> ETCD="${SNAP_DATA}/args/etcd"
### flanneld
* give a subnet to each host for use with container runtimes
> FLANNELD="${SNAP_DATA}/args/flanneld"
### kubelet
* node-agent that runs on each node
> KUBELET="${SNAP_DATA}/args/kubelet"
### proxy
* network proxy runs on each node
> PROXY="${SNAP_DATA}/args/kube-proxy"
### scheduler
* manage resource requirements, qos requirements, data locality, deadlines, and so on
> SCHED="${SNAP_DATA}/args/kube-scheduler"

## Get API master Passwd
kubectl config view | egrep "password|username"
