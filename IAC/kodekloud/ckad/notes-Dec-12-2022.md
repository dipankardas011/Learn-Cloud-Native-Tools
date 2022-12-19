# Core Recap

## Architecture

components of k8s
- api server
- etcd
- controller
- container runtime
- scheduler
- kubelet

> **Note**
> `minion` aka worker nodes

```
kube-apiserver <-------> kubelet
((control plane))       ((worker))
```

## PODs

it's a single instance of an applications 
it encapsulates the containers

