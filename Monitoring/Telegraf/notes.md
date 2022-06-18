for the time series data use InfluxDB

Telegraf is used to collect all the metrics from all the sources and then its visualized with grafana

Chronograf used for the quering
kapacator used for the complex query processing

**relay** is used for syncing betwwen the 2 Influex DB instances so that high avability is attained and so eleminating the need for purchasing entriprise InfluexDB

**batch_size** should be sent at a time to your influxDB instance
**buffer** if the influxDB instance is down so it will continue to send the metrics which gets queued up
examaple, like 2Gi so it will hold once available it will again send it 

> **Kafka Queue** is required when there are thousands of metrics between the **Telegraf** and **InfluxDB**

internal plugin keep an eye on the telegraf as add a 'ALERT on Metrics DROP!'

SnapShots of $ /var/lib/InfluxDB/
all the data, var folders 