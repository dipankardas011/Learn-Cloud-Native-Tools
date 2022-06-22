#!/bin/sh
https://projectcalico.docs.tigera.io/getting-started/kubernetes/k3s/multi-node-install

Control node 192.168.7.81

```sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy --cluster-cidr=192.168.0.0/16" sh -
```


worker node01 192.168.7.162
```sh
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.7.81:6443 K3S_TOKEN=K10d22232453a43901a9cbeee7fc7f70644ee15bca047ed045b476d1ceecef9e6a2::server:b8de53a4fac7f42656e7c0b9d8412b16 sh -
```
worker node02 192.168.7.134
```sh
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.7.81:6443 K3S_TOKEN=K10d22232453a43901a9cbeee7fc7f70644ee15bca047ed045b476d1ceecef9e6a2::server:b8de53a4fac7f42656e7c0b9d8412b16 sh -
```