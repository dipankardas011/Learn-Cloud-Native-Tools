# setup & install

you must be in pwd
```sh
Monitoring/Prometheus/custom-prometheus/manifests
```

1. setup

```sh
# for targets
cd prometheus/
kubectl create ns monitoring
kubectl create secret generic additional-scrape-configs --from-file=prometheus-additional.yaml --dry-run -oyaml > additional-scrape-configs.yaml
kubectl apply -f additional-scrape-configs.yaml -n monitoring
# edited Monitoring/Prometheus/custom-prometheus/manifests/prometheus/prometheus-prometheus.yaml
```

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
