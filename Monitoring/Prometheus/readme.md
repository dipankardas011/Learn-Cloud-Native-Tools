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