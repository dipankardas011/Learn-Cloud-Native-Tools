# Kubernetes Troublshoting 

# Challlegnge 1

```sh
export KUBECONFIG=/etc/kubernetes/admin.conf
```

kubectl describe node kubernetes

Terminting and creating loop in k8s
in this scienerio

> rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial unix /var/run/containerd/containerd.sock: connect: no such file or directory"

so check 
```sh
systemctl status containerd
systemctl start containerd
systemctl restart containerd
```

> /klustered:v1": rpc error: code = Unknown desc = failed to pull and unpack image "ghcr.io/rawkodeacademy/klustered:v1": failed to resolve reference "ghcr.io/rawkodeacademy/klustered:v1": failed to do request: Head https://ghcr.io/v2/rawkodeacademy/klustered/manifests/v1: x509: certificate is valid for *.docker.com, dockercon.com, docker.com, *.docs.docker.com, docs.docker.com, docker.io, *.docker.io, *.dockercon.com, not ghcr.io
```sh
curl -v https://ghcr.io
```

not working so removev the last line in /etc/hosts

the web app is not listening in pod
```sh
netstat -tnlp
lsof -i -P -n | grep LISTEN


ls /proc/self
ls /proc/l/

# to get the port number where is  itrunning

apt install bpfcc-tools

which opensnoop-bpfcc
ls /usr/sbin/ | grep snoop

opensnoop-bpfcc # open tcp connectiona dn log files

execsnoop-bpfcc # execituin commands 


tcpconnect-bpfcc # if process is listening on port number

search for bcc

some where get the port where it is listening which is 666

kubectl edit svc 
# tcpdump can be used

version 1 -> version2

```

# Demo 2

screenshot shows that egress is [] which tells
by default all are deny and so all engree

use cilium 

just delete the cilium delete

```sh
kubectl delete netpol allow-egree
```

if time is there
allow 5432 dns 



then change the v1 -> v2
the rs is changed but deploy is not changed

deployment changed then new rs is created so there is a hierachy 

// allthe static yamls are in are stored

cd /etc/kubernetes/nanifests/

vim  kube-contoller-manager.yaml there change the -replicaset as - is remove

there was no replicaset to run

but here the pod is pending with no error message

found out that no scheduler yaml in the static manifest dir
/etc/kubernetes/manifests


we can manually force the deployment pods to use nodeName where to run this bipasses the scheduler instaed of adding the static manifest


# Chaleges 3

there is not api server running
as kubectl get po not responding


finializers are the commands ehich ensures that arbiterry commands are ran before the its safe to delete the resource is ever truly deleted

these are used to cleanup and reduce som eof theadminsntraction tasks

we have apis erver but it is alive and dead flipping

```sh
cd /var/log/container # for the kubeadm manager
ls -l | grep apis

tail this

found that etcd not working

then check the etcd logs

# to look the pods
cd /var/log/pods
```

```sh
ip addr show
cd /etc/kubernrtes/manifests
vim etcd.yaml

the wrong local ip is used in the manifests file
vim etcd.yaml

:%s/10.5.1.215/10.5.1.3/g
```

> **Note**
when the static manifests are updated then it takse time to refresh

systemctl restart kubelet

[ETCD Cheat sheet](https://www.devops.buzz/public/kubernetes/etcd-cheat-sheet)


```sh
export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/healthcheck-client.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/healthcheck-client.key

apt install etcd-client

etcdctl endpoint status

etcdctl endpoint health


# how to tell if the etcd is full or not
etcdctl alarm list

remove the quota of write bytes

lets spped things up

kubectl delete rs --all
```
