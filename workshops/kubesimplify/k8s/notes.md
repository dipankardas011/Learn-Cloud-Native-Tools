# Kubernetes 101

```sh
iptable -l # inside the node to see the iptable maniintained by the kube proxy
```

kube-system -> all the system resources
kube-public -> contains all the info about the cluster
kube-node-lease -> lease of all the nodes


which resources are not namespaced

```sh
kubectl api-resources --namespaced=false
```

```sh
kubectl delete po dipankar --force
```


empty dir empty dir is inside Node it is emphmiral

pod has 1 IP so multi containers talk to each other by sharing the ip using localhost


```yml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container
spec:
  volumes:
  - name: shared-data
    emptyDir: {}

  containers:
  -  name: nginx-container
     image: nginx
     volumeMounts:
     - name: shared-data
       mountPath: /usr/share/nginx/html
  - name: alpine-container
    image: alpine
    volumeMounts:
    - name: shared-data
      mountPath: /mem-info
    command: ["/bin/sh" , "-c"]
    args:
    - while true; do
        date >> /mem-info/index.html ;
        egrep --color 'Mem|Cache|Swap|' /proc/meminfo >> /mem-info/index.html ;
        sleep 2;
      done
```

```sh
kubectl logs -f multi-container -c alpine-container
```

kubectl create will create the file once
and kubectl apply will apply the changes


## Statefulset

local path provisioner
```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
```

```yml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      storageClassName: local-path
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

CNI create the network namespace and the pause container holds the network namespace
eth from pod ns ->> veth in node ns we use calieo

```sh
ip a | grep eth

3. eth0@if12

ip link | grep -A1 ^12 # here the 12 is the last digits

# here the bridge is used it depends upon the CNI here is caliede
```