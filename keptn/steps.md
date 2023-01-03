# Steps to add the resources

```bash
cd charts/
keptn add-resource --project weather-app --service weather-svc \
  --all-stages \
  --resource=./weather-svc-3.0.0.tgz \
  --resourceUri=charts/weather-svc.tgz

cd ..

# the project structure KEPTN_SERVICE/locust/* and KEPTN_SERVICE/charts/KEPTN_SERVICE.tgz
keptn add-resource \
  --project weather-app \
  --service weather-svc \
  --stage=qa \
  --resource=./locust/locust.conf
keptn add-resource \
  --project weather-app \
  --service weather-svc \
  --stage=qa \
  --resource=./locust/main.py
keptn add-resource \
  --project weather-app \
  --service weather-svc \
  --all-stages \
  --resource=./job/config.yaml \
  --resourceUri=job/config.yaml
```

```bash
keptn trigger delivery --project=weather-app --service=weather-svc --image=docker.io/dipugodocker/weatherapp:v3 \
  --labels=image="docker.io/dipugodocker/weatherapp",version="v3"
```
