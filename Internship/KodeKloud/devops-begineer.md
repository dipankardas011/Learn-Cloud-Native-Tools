---
author: Dipankar Das
topic: devops
subtopic: begineer
---

# Kubernetes Time Check Pod

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: time-config
  namespace: nautilus
data:
  TIME_FREQ: "9"
---
apiVersion: v1
kind: Pod
metadata:
  name: time-check
  namespace: nautilus
spec:
  volumes:
  - name: log-volume
    emptyDir: {}
  containers:
  - name: time-check
    image: busybox:latest
    volumeMounts:
    - name: log-volume
      mountPath: "/opt/sysops/time"
    command: ["/bin/sh"] 
    args: ["-c", "while true; do date >> /opt/sysops/time/time-check.log; sleep $TIME_FREQ; done"]
    env:
    - name: TIME_FREQ
      valueFrom:
        configMapKeyRef:
          name: time-config
          key: TIME_FREQ
```

# 

```yml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
  namespace: jenkins
  labels:
    app: jenkins
spec:
  selector:
    matchLabels:
      app: jenkins
  replicas: 1
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
      - name: jenkins-container
        image: jenkins/jenkins
        ports:
          - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - targetPort: 8080
      nodePort: 30008
      port: 8080
...
```
