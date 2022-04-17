```bash
$ kubectl create deploy nginx --image=nginx --port=80

$ kubectl get deploy

$ kubectl delete deploy <name>


#to create using file
$ kubectl create -f deploy.yaml

$ kubectl api-resources

$ for helm carts
$ helm list
$ helm delete <name>
```

namespace
unique name for same object but different -different name for other
groups
```bash
$ kubectl get ns
$ kubectl create ns <name>
```
to helps to have set quotas

dev team, testing team having diff quotas
```bash
$ kubectl create deploy nginx --image=nginx
this is createing the default namespace of nginx as it is not providede

# for creating the pod in different namespace
$ kubectl create deploy nginx --image=nginx -n dev

# to view
kubectl get pods -n dev

# to rem the pod from namespace
$ kubectl delete deploy nginx -n dev
# to delete the namespace
$ kubectl delete ns dev


# by default the get pods gives the deafult namespce
// inorder make other namespace by default
$ kubectl config set-context --current --namespace=<namespace>

# to view the dafult view of the namespace
$ kubectl config view --minify | grep namespace
```

# labels
are the key:value pair that are attached to kubernetes objects i.e. PODS


it basilclly provides attributes which creates meaningful kubernetes cluster

adding label after creating the pod
```bash
$ kubectl label pod nginx demo=true
```
----------------------------------------------------------------
```bash
kubectl config current-context
❌❌
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

sudo sysctl -p
# ++++++++++++++++++++++++++++++++++++++++
# @@@@ Error Occurs @@@@
# $ modprobe bridge
# $ echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
# $ sysctl -p /etc/sysctl.conf

# 🚫sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-ip6tables: No such file or directory

# SOLUTION
$ modprobe br_netfilter
$ sysctl -p /etc/sysctl.conf
# ++++++++++++++++++++++++++++++++++++++

sudo apt-get update && sudo apt-get install -y containerd

sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd

sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

sudo swapoff -a

```
@@ Control Node @@
```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --control-plane-endpoint="control-node:6443"

# kubeadm init --control-plane-endpoint="<control vm name>:6443"
# kubeadm init --control-plane-endpoint="control-node:6443"

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

```
@@ Worker node @@
```bash
sudo kubeadm join <>

# when the showing not ready
[More info about the ip protocle](https://biarca.com/2018/10/choosing-the-right-network-for-your-kubernetes-cluster/)

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
to solve the not ready state
----------------------------------------------------------------------------------
civo kubernetes create <cluster name> --size=g3.k3s.medium --nodes=2 --wait

## objects
```bash
kubectl get pods -o wide

kubectl logs -f <pod name> // for the log files

kubectl describe pod <pod name>// for the events in the pods

kubectl delete <pod name>
kubectl exec -it <pod name> bash


kubeadm join 10.0.0.4:6443 --token bdw4lv.a6quoksex38khglg --discovery-token-ca-cert-hash sha256:199c07a21ad13ad9d93aed3129b01c9d18eef91532398fb0297a44b3eec6f879

```



[ERROR FileContent–proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables contents are not set to 1
4 Replies	

