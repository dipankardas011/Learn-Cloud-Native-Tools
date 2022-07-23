
K8s 1.24
---

![JWT](jwt.io)
from this version when you create a service account it will **not** create a secret token automatically

so you have to create if by yourself whose default expire duration is 1h

```sh
kubectl create sa demo

kubectl create token demo
kubectl create token demo --duration=1000h
kubectl get secrets




# lets create a pod with the given service account
kubectl run nginx --image=nginx:alpine --overrides='{"spec":{"serviceAccount":"demo"}}'
```
creating secret using file is not descurity best practise as there is not expire date
```sh
kubectl apply -f demo-token.yml
kubectl describe secret <>
```
