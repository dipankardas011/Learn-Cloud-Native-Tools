# Security

## ConfigMaps

### .prop file
```bash
# creating test configMap from a file
kubectl create configmap test --from-file=file.prop

kubectl describe cm test
```

### env files
sometimes we have multiple key value in a file want to store it in a seperate datas
using [env files]()

```bash
# creating test configMap from a file
kubectl create configmap test2 --from-env-file=env.prop

kubectl describe cm test2
```

### using liternal
```bash
kubectl create cm demo-my-name --from-literal=name=dipankar
```

## using ConfigMap

file = Kubernetes/secrets/demo-from-cm.yaml

## Secrets

### using yaml way
![](./01.png)
sec.yml

### using imperiative way
```bash
kubectl create secret generic admin --from-literal=admin-user=admin
kubectl create secret generic dev --from-literal=dev-user=dev
```

## Access
![](./02.png)
