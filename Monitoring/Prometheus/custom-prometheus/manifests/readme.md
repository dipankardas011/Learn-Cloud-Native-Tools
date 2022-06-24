# setup & install

1. setup

```sh
kubectl create -f setup -n monitoring
```

2. prometheusOperator

```sh
kubectl apply -f prometheusOperator -n monitoring
```

3. nodeExporter

4. alertmanager

5. kubestatemaetrics

```sh
kubectl apply -f nodeExporter -n monitoring
kubectl apply -f kubeStateMetrics -n monitoring
kubectl apply -f alertmanager -n monitoring
kubectl apply -f prometheus -n monitoring
kubectl apply -f grafana -n monitoring

```

5. prometheus

6. grafana

used the upstream prometheus-operator/kube-prometheus
