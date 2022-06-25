# Install guide
```bash
# download from here https://prometheus.io/download
$ tar xvfz prometheus-*.tar.gz
$ cd prometheus-*

# to config the prometheus edit the prometheus.yml
# to run in default port localhost:9090
$ ./prometheus --config.file=config.yml
```

[Getting Started](https://prometheus.io/docs/prometheus/latest/getting_started/)

# for the password protected

python run password.py # to generate a password hash
# then use it to add
web.yml
```yaml
basic_auth_users:
    admin: $2b$12$hNf2lSsxfm0.i4a.1kVpSOVyBCfIB51VRjgBUyv6kdnyTlgWj81Ay
```
```sh
# with auth
./promtool check web-config web.yml
./prometheus --web.config.file=web.yml --config.file=prometheus.yml
# for no-auth
./prometheus --config.file=prometheus.yml
```
https://prometheus.io/docs/prometheus/latest/configuration/https/

[CivoGuid](https://www.civo.com/learn/kubernetes-monitoring-with-prometheus-and-grafana?utm_content=buffer6db09&utm_medium=organic-twitter&utm_source=twitter&utm_campaign=civo-buffer)

[KubeSphere](https://docs.google.com/presentation/d/1Z7FtqKsZJEoTrN1Lpnm5SkC5bNKl4jUyGSi4PLA4MU8/edit#slide=id.g106ddafd2d0_2_248)


[Custom metrics in go](https://prometheus.io/docs/guides/go-application/)

You can configure a locally running Prometheus instance to scrape metrics from the application. Here's an example prometheus.yml configuration:
```yaml
scrape_configs:
- job_name: myapp
  scrape_interval: 10s
  static_configs:
  - targets:
    - localhost:2112
```


```promql
increase(promhttp_metric_handler_requests_total{job="my-pdf-app"}[$__interval])
```

# Submodules
* Kube-prometheus/ from the **coreos**
* helm-charts/ from **kube-prometheus**

# Ways to install Prometheus stack
There are three different ways to setup the Prometheus monitoring stack in Kubernetes.
1. Creating everything on your own
2. Using Prometheus Operator
3. Using Helm chart to deploy operator

# 3 types of monitoring
1. application monitoring
  - process monitoring (OS generates) cpu,memory,disk,network 
  - custom monitoring 
2. infrastructure monitoring
  - Node exporter (how the nodes are performing in terms of Control plane)cpu,memory,disk,network
3. Kubernetes monitoring
  - Kube state metrics (pod,ingress,deployments cpu,memory,network)
  - API server (lifecycle of our pods) (worload status)
  - kubelet because it has some key container metrics

[AlertManager Gmail&Slack](https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/)