# start the prometheus server (LOCALLY)

```sh
./prometheus --web.config.file=web.yml --config.file=prometheus.yml
# password is 1234
curl -u admin localhost:9090/metrics
```