# Starting
![](https://linkerd.io/images/architecture/control-plane.png)
```sh
kind create cluster

linkerd check --pre
linkerd install | kubectl apply -f -
linkerd check

# then go on

# install dashboard
linkerd viz install | kubectl apply -f -
linkerd check
linkerd viz dashboard &

# to monitor how and what to retries
# we use service policies with isRetryable: true, etc..
```

Linkerd-SMI extension for traffic splitting
![Link of docs](https://linkerd.io/2.11/tasks/linkerd-smi/#install-the-linkerd-smi-extension)

# Canary release using Flagger
![Docs link](https://linkerd.io/2.11/tasks/canary-release/)

```sh
cat <<EOF | kubectl apply -f -
apiVersion: flagger.app/v1beta1
kind: Canary
metadata:
  name: podinfo
  namespace: test
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: podinfo
  service:
    port: 9898
  analysis:
    interval: 10s
    threshold: 5
    stepWeight: 10
    maxWeight: 100
    metrics:
    - name: request-success-rate
      thresholdRange:
        min: 99
      interval: 1m
    - name: request-duration
      thresholdRange:
        max: 500
      interval: 1m
EOF
```

# Argocd
[Docs Link](https://linkerd.io/2.11/tasks/gitops/)