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
