# from scratch create K8s CNCF way

[Link of blog](https://medium.com/@norlin.t/build-a-managed-kubernetes-cluster-from-scratch-part-1-fca5f6b3639b)

# How to setup a HA K8s cluster using kind

```yaml
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker


# HA
# a cluster with 3 control-plane nodes and 3 workers
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: control-plane
- role: control-plane
- role: worker
- role: worker
- role: worker
```

```sh
kind create cluster --config kind-example-config.yaml
```



# kind with cilium

```sh
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true
```


[Cluster-AutoScaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md)


# Kubeadm approach

[Link fof saiyam gist](https://gist.github.com/saiyam1814/801db1288c690a969e7174eca89c65b2)
