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

## ReplicaSets

> Replication constoller is replaced by replica set

```bash
# to scale replica sets
kubectl replace -f <>.yaml

kubectl scale --replicas=6 replicaset/myapp-rs
```

## Deployment

similar to replicaset just added rolling updates

## Namespace

same namespace by the service name
other namespace then FQDN is required <servicename>.namespace.svc.cluster.local

kubectl config set-context --current -n dev

**Resource quota**
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev

spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
    limits.memory: 10Gi
...
```
