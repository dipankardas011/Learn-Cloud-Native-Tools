# Initial Prometheus Setup
Step 1 - Start initial Prometheus servers
Thanos is meant to scale and extend vanilla Prometheus. This means that you can gradually, without disruption, deploy Thanos on top of your existing Prometheus setup.

Let's start our tutorial by spinning up three Prometheus servers. Why three? The real advantage of Thanos is when you need to scale out Prometheus from a single replica. Some reason for scale-out might be:

Adding functional sharding because of metrics high cardinality
Need for high availability of Prometheus e.g: Rolling upgrades
Aggregating queries from multiple clusters
For this course, let's imagine the following situation:

initial-case

We have one Prometheus server in some eu1 cluster.
We have 2 replica Prometheus servers in some us1 cluster that scrapes the same targets.
Let's start this initial Prometheus setup for now.

Prometheus Configuration Files
Now, we will prepare configuration files for all Prometheus instances.

Click Copy To Editor for each config to propagate the configs to each file.

First, for the EU Prometheus server that scrapes itself:

Copy to Editor
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: eu1
    replica: 0

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9090']
```
For the second cluster we set two replicas:

Copy to Editor
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: us1
    replica: 0

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9091','127.0.0.1:9092']
```
Copy to Editor
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: us1
    replica: 1

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9091','127.0.0.1:9092']
```
NOTE : Every Prometheus instance must have a globally unique set of identifying labels. These labels are important as they represent certain "stream" of data (e.g in the form of TSDB blocks). Within those exact external labels, the compactions and downsampling are performed, Querier filters its store APIs, further sharding option, deduplication, and potential multi-tenancy capabilities are available. Those are not easy to edit retroactively, so it's important to provide a compatible set of external labels as in order to for Thanos to aggregate data across all the available instances.

Starting Prometheus Instances
Let's now start three containers representing our three different Prometheus instances.

Please note the extra flags we're passing to Prometheus:

`--web.enable-admin-api` allows Thanos Sidecar to get metadata from Prometheus like external labels.
`--web.enable-lifecycle` allows Thanos Sidecar to reload Prometheus configuration and rule files if used.
Execute following commands:

Prepare "persistent volumes"
mkdir -p prometheus0_eu1_data prometheus0_us1_data prometheus1_us1_data
Deploying "EU1"
```sh
docker run -d --net=host --rm \
    -v $(pwd)/prometheus0_eu1.yml:/etc/prometheus/prometheus.yml \
    -v $(pwd)/prometheus0_eu1_data:/prometheus \
    -u root \
    --name prometheus-0-eu1 \
    quay.io/prometheus/prometheus:v2.14.0 \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/prometheus \
    --web.listen-address=:9090 \
    --web.external-url=https://872f814b4d5740cc8200c28a6a855deb-167772166-9090-simba09b.environments.katacoda.com \
    --web.enable-lifecycle \
    --web.enable-admin-api && echo "Prometheus EU1 started!"
```
NOTE: We are using the latest Prometheus image so we can take profit from the latest remote read protocol.

Deploying "US1"
```sh
docker run -d --net=host --rm \
    -v $(pwd)/prometheus0_us1.yml:/etc/prometheus/prometheus.yml \
    -v $(pwd)/prometheus0_us1_data:/prometheus \
    -u root \
    --name prometheus-0-us1 \
    quay.io/prometheus/prometheus:v2.14.0 \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/prometheus \
    --web.listen-address=:9091 \
    --web.external-url=https://872f814b4d5740cc8200c28a6a855deb-167772166-9091-simba09b.environments.katacoda.com \
    --web.enable-lifecycle \
    --web.enable-admin-api && echo "Prometheus 0 US1 started!"
```
and
```sh
docker run -d --net=host --rm \
    -v $(pwd)/prometheus1_us1.yml:/etc/prometheus/prometheus.yml \
    -v $(pwd)/prometheus1_us1_data:/prometheus \
    -u root \
    --name prometheus-1-us1 \
    quay.io/prometheus/prometheus:v2.14.0 \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/prometheus \
    --web.listen-address=:9092 \
    --web.external-url=https://872f814b4d5740cc8200c28a6a855deb-167772166-9092-simba09b.environments.katacoda.com \
    --web.enable-lifecycle \
    --web.enable-admin-api && echo "Prometheus 1 US1 started!"
```
Setup Verification
Once started you should be able to reach all of those Prometheus instances:

Prometheus-0 EU1
Prometheus-1 US1
Prometheus-2 US1
Additional info
Why would one need multiple Prometheus instances?

High Availability (multiple replicas)
Scaling ingestion: Functional Sharding
Multi cluster/environment architecture
Problem statement: Global view challenge
Let's try to play with this setup a bit. You are free to query any metrics, however, let's try to fetch some certain information from our multi-cluster setup: How many series (metrics) we collect overall on all Prometheus instances we have?

Tip: Look for prometheus_tsdb_head_series metric.

🕵️‍♂️

Try to get this information from the current setup!

To see the answer to this question click SHOW SOLUTION below.

Next
Great! We have now running 3 Prometheus instances.

In the next steps, we will learn how we can install Thanos on top of our initial Prometheus setup to solve problems shown in the challenge.


# Thanos Sidecars
Step 2 - Installing Thanos sidecar
Let's take the setup from the previous step and seamlessly install Thanos to add Global View with HA handling feature.

Thanos Components
Thanos is a single Go binary capable to run in different modes. Each mode represents a different component and can be invoked in a single command.

Let's take a look at all the Thanos commands:
```sh
docker run --rm quay.io/thanos/thanos:v0.26.0 --help
```
You should see multiple commands that solves different purposes.

In this step we will focus on thanos sidecar:
```
  sidecar [<flags>]
    sidecar for Prometheus server
```
Sidecar
Sidecar as the name suggests should be deployed together with Prometheus. Sidecar has multiple features:

It exposes Prometheus metrics as a common Thanos StoreAPI. StoreAPI is a generic gRPC API allowing Thanos components to fetch metrics from various systems and backends.
It is essentially in further long term storage options described in next courses.
It is capable to watch for configuration and Prometheus rules (alerting or recording) and notify Prometheus for dynamic reloads:
optionally substitute with environment variables
optionally decompress if gzipp-ed
You can read more about sidecar here

Installation
To allow Thanos to efficiently query Prometheus data, let's install sidecar to each Prometheus instances we deployed in the previous step as shown below:

sidecar install

For this setup the only configuration required for sidecar is the Prometheus API URL and access to the configuration file. Former will allow us to access Prometheus metrics, the latter will allow sidecar to reload Prometheus configuration in runtime.

Click snippets to add sidecars to each Prometheus instance.

Adding sidecar to "EU1" Prometheus
```sh
docker run -d --net=host --rm \
    -v $(pwd)/prometheus0_eu1.yml:/etc/prometheus/prometheus.yml \
    --name prometheus-0-sidecar-eu1 \
    -u root \
    quay.io/thanos/thanos:v0.26.0 \
    sidecar \
    --http-address 0.0.0.0:19090 \
    --grpc-address 0.0.0.0:19190 \
    --reloader.config-file /etc/prometheus/prometheus.yml \
    --prometheus.url http://127.0.0.1:9090 && echo "Started sidecar for Prometheus 0 EU1"
```
Adding sidecars to each replica of Prometheus in "US1"
```sh
docker run -d --net=host --rm \
    -v $(pwd)/prometheus0_us1.yml:/etc/prometheus/prometheus.yml \
    --name prometheus-0-sidecar-us1 \
    -u root \
    quay.io/thanos/thanos:v0.26.0 \
    sidecar \
    --http-address 0.0.0.0:19091 \
    --grpc-address 0.0.0.0:19191 \
    --reloader.config-file /etc/prometheus/prometheus.yml \
    --prometheus.url http://127.0.0.1:9091 && echo "Started sidecar for Prometheus 0 US1"
```
```sh
docker run -d --net=host --rm \
    -v $(pwd)/prometheus1_us1.yml:/etc/prometheus/prometheus.yml \
    --name prometheus-1-sidecar-us1 \
    -u root \
    quay.io/thanos/thanos:v0.26.0 \
    sidecar \
    --http-address 0.0.0.0:19092 \
    --grpc-address 0.0.0.0:19192 \
    --reloader.config-file /etc/prometheus/prometheus.yml \
    --prometheus.url http://127.0.0.1:9092 && echo "Started sidecar for Prometheus 1 US1"
```
Verification
Now, to check if sidecars are running well, let's modify Prometheus scrape configuration to include our added sidecars.

As always click Copy To Editor for each config to propagate the configs to each file.

Note that only thanks to the sidecar, all those changes will be immediately reloaded and updated in Prometheus!

Copy to Editor
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: eu1
    replica: 0

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9090']
  - job_name: 'sidecar'
    static_configs:
      - targets: ['127.0.0.1:19090']
```
Copy to Editor
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: us1
    replica: 0

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9091','127.0.0.1:9092']
  - job_name: 'sidecar'
    static_configs:
      - targets: ['127.0.0.1:19091','127.0.0.1:19092']
```
Copy to Editor
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: us1
    replica: 1

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9091','127.0.0.1:9092']
  - job_name: 'sidecar'
    static_configs:
      - targets: ['127.0.0.1:19091','127.0.0.1:19092']
```
Now you should see new, updated configuration on each Prometheus. For example here in Prometheus 0 EU1 /config. In the same time up should show job=sidecar metrics.

Since now Prometheus has access to sidecar metrics we can query for thanos_sidecar_prometheus_up to check if sidecar has access to Prometheus.

Next
Great! Now you should have setup deployed as in the presented image:

sidecar install

In the next step, we will add a final component allowing us to fetch Prometheus metrics from a single endpoint.

# Thanos Querier
Step 3 - Adding Thanos Querier
Thanks to the previous step we have three running Prometheus instances with a sidecar each. In this step we will install Thanos Querier which will use sidecars and allow querying all metrics from the single place as presented below:

![with querier](https://docs.google.com/drawings/d/e/2PACX-1vSB9gN82px0lxk9vN6wNw3eXr8Z0EVROW3xubsq7tgjbx_nXsoZ02ElzvxeDevyjGPWv-f9Gie0NeNz/pub?w=926&h=539)

But before that, let's take a closer look at what the Querier component does:

Querier
The Querier component (also called "Query") is essentially a vanilla PromQL Prometheus engine that fetches the data from any service that implements Thanos StoreAPI. This means that Querier exposes the Prometheus HTTP v1 API to query the data in a common PromQL language. This allows compatibility with Grafana or other consumers of Prometheus' API.

Additionally, Querier is capable of deduplicating StoreAPIs that are in the same HA group. We will see how it looks in practice later on.

You can read more about Thanos Querier here

Deploying Thanos Querier
Let's now start the Query component. As you remember Thanos sidecar exposes StoreAPI so we will make sure we point the Querier to the gRPC endpoints of all our three sidecars:

Click the snippet below to start the Querier.
```sh
docker run -d --net=host --rm \
    --name querier \
    quay.io/thanos/thanos:v0.26.0 \
    query \
    --http-address 0.0.0.0:29090 \
    --query.replica-label replica \
    --store 127.0.0.1:19190 \
    --store 127.0.0.1:19191 \
    --store 127.0.0.1:19192 && echo "Started Thanos Querier"
```
Setup verification
Thanos Querier exposes very similar UI to the Prometheus, but on top of many `StoreAPIs you wish to connect to.

To check if the Querier works as intended let's look on Querier UI Store page.

This should list all our three sidecars, including their external labels.

```
promQL
> sum(prometheus_tsdb_head_series)

> prometheus_tsdb_head_series
```

Global view - Not challenging anymore?
Now, let's get back to our challenge from step 1, so finding the answer to How many series (metrics) we collect overall on all Prometheus instances we have?

With the querier this is now super simple.

It's just enough to query Querier for sum(prometheus_tsdb_head_series)

You should see the single value representing the number of series scraped in both clusters in the current mode.

If we query prometheus_tsdb_head_series we will see that we have complete info about all three Prometheus instances:
```PromQL
prometheus_tsdb_head_series{cluster="eu1",instance="127.0.0.1:9090",job="prometheus"}
prometheus_tsdb_head_series{cluster="us1",instance="127.0.0.1:9091",job="prometheus"}
prometheus_tsdb_head_series{cluster="us1",instance="127.0.0.1:9092",job="prometheus"}
```
Handling of Highly Available Prometheus
Now, as you remember we configured Prometheus 0 US1 and Prometheus 1 US1 to scrape the same things. We also connect Querier to both, so how Querier knows what is an HA group?

Try to query the same query as before: prometheus_tsdb_head_series

Now turn off deduplication (deduplication button on Querier UI) and hit Execute again. Now you should see 5 results:
```PromQL
prometheus_tsdb_head_series{cluster="eu1",instance="127.0.0.1:9090",job="prometheus",replica="0"}
prometheus_tsdb_head_series{cluster="us1",instance="127.0.0.1:9091",job="prometheus",replica="0"}
prometheus_tsdb_head_series{cluster="us1",instance="127.0.0.1:9091",job="prometheus",replica="1"}
prometheus_tsdb_head_series{cluster="us1",instance="127.0.0.1:9092",job="prometheus",replica="0"}
prometheus_tsdb_head_series{cluster="us1",instance="127.0.0.1:9092",job="prometheus",replica="1"}
```
So how Thanos Querier knows how to deduplicate correctly?

If we would look again into Querier configuration we can see that we also set query.replica-label flag. This is exactly the label Querier will try to deduplicate by for HA groups. This means that any metric with exactly the same labels except replica label will be assumed as the metric from the same HA group, and deduplicated accordingly.

If we would open prometheus1_us1.yml config file in the editor or if you go to Prometheus 1 US1 /config. you should see our external labels in external_labels YAML option:
```yml
  external_labels:
    cluster: us1
    replica: 1
```
Now if we compare to prometheus0_us1.yaml:
```yml
  external_labels:
    cluster: us1
    replica: 0
```
We can see that since those two replicas scrape the same targets, any metric will be produced twice. Once by replica=1, cluster=us1 Prometheus and once by replica=0, cluster=us1 Prometheus. If we configure Querier to deduplicate by replica we can transparently handle this High Available pair of Prometheus instances to the user.

Production deployment
Normally Querier runs in some central global location (e.g next to Grafana) with remote access to all Prometheus-es (e.g via ingress, proxies vpn or peering)

You can also stack (federate) Queriers on top of other Queries, as Query expose StoreAPI as well!

More information about those advanced topics can be found in the next courses that will be added soon.

Next
Awesome! Feel free to play around with the following setup:

with querier

Once done hit Continue for summary.

![](https://docs.google.com/drawings/d/e/2PACX-1vSB9gN82px0lxk9vN6wNw3eXr8Z0EVROW3xubsq7tgjbx_nXsoZ02ElzvxeDevyjGPWv-f9Gie0NeNz/pub?w=926&h=539)


# Configuring Initial Prometheus Server
Step 1 - Initial Prometheus Setup
In this tutorial, we will mimic the usual state with a Prometheus server running for... a year!. We will use it to seamlessly backup all old data in the object storage and configure Prometheus for continuous backup mode, which will allow us to cost-effectively achieve unlimited retention for Prometheus.

Last but not the least, we will go through setting all up for querying and automated maintenance (e.g compactions, retention and downsampling).

In order to showcase all of this, let's start with a single cluster setup from the previous course. Let's start this initial Prometheus setup, ready?

Generate Artificial Metrics for 1 year
Actually, before starting Prometheus, let's generate some artificial data. You most likely want to learn about Thanos fast, so you probably don't have months to wait for this tutorial until Prometheus collects the month of metrics, do you? (:

We will use our handy thanosbench project to do so! Let's generate Prometheus data (in form of TSDB blocks) with just 5 series (gauges) that spans from a year ago until now (-6h)!

Execute the following command (should take few seconds):
```sh
mkdir -p /root/prom-eu1 && docker run -i quay.io/thanos/thanosbench:v0.2.0-rc.1 block plan -p continuous-365d-tiny --labels 'cluster="eu1"' --max-time=6h | docker run -v /root/prom-eu1:/prom-eu1 -i quay.io/thanos/thanosbench:v0.2.0-rc.1 block gen --output.dir prom-eu1
```
On successful block creation you should see following log lines:
```
level=info ts=2020-10-20T18:28:42.625041939Z caller=block.go:87 msg="all blocks done" count=13
level=info ts=2020-10-20T18:28:42.625100758Z caller=main.go:118 msg=exiting cmd="block gen"
```
Run the below command to see dozens of generated TSDB blocks:
ls -lR /root/prom-eu1
Prometheus Configuration File
Here, we will prepare configuration files for the Prometheus instance that will run with our pre-generated data. It will also scrape our components we will use in this tutorial.

Click Copy To Editor for config to propagate the configs to file.

Copy to Editor
```yml
global:
  scrape_interval: 5s
  external_labels:
    cluster: eu1
    replica: 0
    tenant: team-eu # Not needed, but a good practice if you want to grow this to multi-tenant system some day.

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['127.0.0.1:9090']
  - job_name: 'sidecar'
    static_configs:
      - targets: ['127.0.0.1:19090']
  - job_name: 'minio'
    metrics_path: /minio/prometheus/metrics
    static_configs:
      - targets: ['127.0.0.1:9000']
  - job_name: 'querier'
    static_configs:
      - targets: ['127.0.0.1:9091']
  - job_name: 'store_gateway'
    static_configs:
      - targets: ['127.0.0.1:19091']
```
Starting Prometheus Instance
Let's now start the container representing Prometheus instance.

Note -v /root/prom-eu1:/prometheus \ and --storage.tsdb.path=/prometheus that allows us to place our generated data in Prometheus data directory.

Let's deploy Prometheus now. Note that we disabled local Prometheus compactions storage.tsdb.max-block-duration and min flags. Currently, this is important for the basic object storage backup scenario to avoid conflicts between the bucket and local compactions. Read more here.

We also extend Prometheus retention: --storage.tsdb.retention.time=1000d. This is because Prometheus by default removes all data older than 2 weeks. And we have a year (:

Deploying "EU1"
```sh
docker run -d --net=host --rm \
    -v /root/editor/prometheus0_eu1.yml:/etc/prometheus/prometheus.yml \
    -v /root/prom-eu1:/prometheus \
    -u root \
    --name prometheus-0-eu1 \
    quay.io/prometheus/prometheus:v2.20.0 \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.retention.time=1000d \
    --storage.tsdb.path=/prometheus \
    --storage.tsdb.max-block-duration=2h \
    --storage.tsdb.min-block-duration=2h \
    --web.listen-address=:9090 \
    --web.external-url=https://716872989673482d9650497ae8e600b6-167772178-9090-ollie09.environments.katacoda.com \
    --web.enable-lifecycle \
    --web.enable-admin-api
```
Setup Verification
Once started you should be able to reach the Prometheus instance here and query.. 1 year of data!

Prometheus-0 EU1
Thanos Sidecar & Querier
Similar to previous course, let's setup global view querying with sidecar:
```sh
docker run -d --net=host --rm \
    --name prometheus-0-eu1-sidecar \
    -u root \
    quay.io/thanos/thanos:v0.26.0 \
    sidecar \
    --http-address 0.0.0.0:19090 \
    --grpc-address 0.0.0.0:19190 \
    --prometheus.url http://127.0.0.1:9090
```
And Querier. As you remember Thanos sidecar exposes StoreAPI so we will make sure we point the Querier to the gRPC endpoints of the sidecar:
```sh
docker run -d --net=host --rm \
    --name querier \
    quay.io/thanos/thanos:v0.26.0 \
    query \
    --http-address 0.0.0.0:9091 \
    --query.replica-label replica \
    --store 127.0.0.1:19190
```
Setup verification
Similar to previous course let's check if the Querier works as intended. Let's look on Querier UI Store page.

This should list the sidecar, including the external labels.

On graph you should also see our 5 series for 1y time, thanks to Prometheus and sidecar StoreAPI: Graph
```
#promql
continuous_app_metric0
```

# Thanos Sidecars
Step 2 - Object Storage Continuous Backup
Maintaining one year of data within your Prometheus is doable, but not easy. It's tricky to resize, backup or maintain this data long term. On top of that Prometheus does not do any replication, so any unavailability of Prometheus results in query unavailability.

This is where Thanos comes to play. With a single configuration change we can allow Thanos Sidecar to continuously upload blocks of metrics that are periodically persisted to disk by the Prometheus.

NOTE: Prometheus when scraping data, initially aggregates all samples in memory and WAL (on-disk write-head-log). Only after 2-3h it "compacts" the data into disk in form of 2h TSDB block. This is why we need to still query Prometheus for latest data, but overall with this change we can keep Prometheus retention to minimum. It's recommended to keep Prometheus retention in this case at least 6 hours long, to have safe buffer for a potential event of network partition.

Starting Object Storage: Minio
Let's start simple S3-compatible Minio engine that keeps data in local disk:
```sh
mkdir /root/minio && \
docker run -d --rm --name minio \
     -v /root/minio:/data \
     -p 9000:9000 -e "MINIO_ACCESS_KEY=minio" -e "MINIO_SECRET_KEY=melovethanos" \
     minio/minio:RELEASE.2019-01-31T00-31-19Z \
     server /data
```
Create thanos bucket:

mkdir /root/minio/thanos
Verification
To check if the Minio is working as intended, let's open Minio server UI

Enter the credentials as mentioned below:

> Access Key = `minio` Secret Key = `melovethanos`

Sidecar block backup
All Thanos components that use object storage uses the same objstore.config flag with the same "little" bucket config format.

Click Copy To Editor for config to propagate the configs to the file bucket_storage.yaml:

Copy to Editor
```yml
type: S3
config:
  bucket: "thanos"
  endpoint: "127.0.0.1:9000"
  insecure: true
  signature_version2: true
  access_key: "minio"
  secret_key: "melovethanos"
```
Let's restart sidecar with updated configuration in backup mode.
```sh
docker stop prometheus-0-eu1-sidecar
```
Thanos sidecar allows to backup all the blocks that Prometheus persists to the disk. In order to accomplish this we need to make sure that:

Sidecar has direct access to the Prometheus data directory (in our case host's /root/prom-eu1 dir) (--tsdb.path flag)
Bucket configuration is specified --objstore.config-file
--shipper.upload-compacted has to be set if you want to upload already compacted blocks when sidecar starts. Use this only when you want to upload blocks never seen before on new Prometheus introduced to Thanos system.
Let's run sidecar:
```sh
docker run -d --net=host --rm \
    -v /root/editor/bucket_storage.yaml:/etc/thanos/minio-bucket.yaml \
    -v /root/prom-eu1:/prometheus \
    --name prometheus-0-eu1-sidecar \
    -u root \
    quay.io/thanos/thanos:v0.26.0 \
    sidecar \
    --tsdb.path /prometheus \
    --objstore.config-file /etc/thanos/minio-bucket.yaml \
    --shipper.upload-compacted \
    --http-address 0.0.0.0:19090 \
    --grpc-address 0.0.0.0:19190 \
    --prometheus.url http://127.0.0.1:9090
```
Verification
We can check whether the data is uploaded into thanos bucket by visitng Minio. It will take couple of seconds to synchronize all blocks.

Once all blocks appear in the minio thanos bucket, we are sure our data is backed up. Awesome! 💪



# Thanos Store Gateway
Step 3 - Fetching metrics from Bucket
In this step, we will learn about Thanos Store Gateway and how to deploy it.

Thanos Components
Let's take a look at all the Thanos commands:
```sh
docker run --rm quay.io/thanos/thanos:v0.26.0 --help
```
You should see multiple commands that solve different purposes, block storage based long-term storage for Prometheus.

In this step we will focus on thanos store gateway:

  store [<flags>]
    Store node giving access to blocks in a bucket provider
Store Gateway:
This component implements the Store API on top of historical data in an object storage bucket. It acts primarily as an API gateway and therefore does not need significant amounts of local disk space.
It keeps a small amount of information about all remote blocks on the local disk and keeps it in sync with the bucket. This data is generally safe to delete across restarts at the cost of increased startup times.
You can read more about Store here.

Deploying store for "EU1" Prometheus data
```sh
docker run -d --net=host --rm \
    -v /root/editor/bucket_storage.yaml:/etc/thanos/minio-bucket.yaml \
    --name store-gateway \
    quay.io/thanos/thanos:v0.26.0 \
    store \
    --objstore.config-file /etc/thanos/minio-bucket.yaml \
    --http-address 0.0.0.0:19091 \
    --grpc-address 0.0.0.0:19191
```
How to query Thanos store data?
In this step, we will see how we can query Thanos store data which has access to historical data from the thanos bucket, and play with this setup a bit.

Currently querier does not know about store yet. Let's change it by adding Store Gateway gRPC address --store 127.0.0.1:19191 to Querier:
```sh
docker stop querier && \
docker run -d --net=host --rm \
   --name querier \
   quay.io/thanos/thanos:v0.26.0 \
   query \
   --http-address 0.0.0.0:9091 \
   --query.replica-label replica \
   --store 127.0.0.1:19190 \
   --store 127.0.0.1:19191
```
Click on the Querier UI Graph page and try querying data for a year or two by inserting metrics continuous_app_metric0 (Query UI). Make sure deduplication is selected and you will be able to discover all the data fetched by Thanos store.

![](https://github.com/thanos-io/thanos/raw/main/tutorials/katacoda/thanos/2-lts/query.png)

Also, you can check all the active endpoints located by thanos-store by clicking on Stores.

What we know so far?
We've added Thanos Query, a component that can query a Prometheus instance and Thanos Store at the same time, which gives transparent access to the archived blocks and real-time metrics. The vanilla PromQL Prometheus engine used inside Query deduces what time series and for what time ranges we need to fetch the data for.

Also, StoreAPIs propagate external labels and the time range they have data for, so we can do basic filtering on this. However, if you don't specify any of these in the query (only "up" series) the querier concurrently asks all the StoreAPI servers.

The potential duplication of data between Prometheus+sidecar results and store Gateway will be transparently handled and invisible in results.

Checking what StoreAPIs are involved in query
Another interesting question here is how to ensure if we query the data from bucket only?

We can check this by visitng the New UI, inserting continuous_app_metric0 metrics again with 1 year time range of graph, and click on Enable Store Filtering.

This allows us to filter stores and helps in debugging from where we are querying the data exactly.

Let's chose only 127.0.0.1:19191, so store gateway. This query will only hit that store to retrieve data, so we are sure that store works.



## Questions
In an HA Prometheus setup with Thanos sidecars, would there be issues with multiple sidecars attempting to upload the same data blocks to object storage?

This is handled by having unique external labels for all Prometheus, sidecar instances and HA replicas. To indicate that all replicas are storing same targets, they differ only in one label.

For an instance, consider the situation below:
```yml
First:
"cluster": "prod1"
"replica": "0"

Second:
"cluster":"prod1"
"replica": "1"
```
There is no problem with storing them since the label sets are unique.



# Thanos Compactor
Step 4 - Thanos Compactor
In this step, we will install Thanos Compactor which applies the compaction, retention, deletion and downsampling operations on the TSDB block data object storage.

Before, moving forward, let's take a closer look at what the Compactor component does:

> Note: Thanos Compactor is currently designed to be run as a singleton. Unavailability (hours) is not problematic as it does not serve any live requests.

Compactor
The Compactor is an essential component that operates on a single object storage bucket to compact, downsample, apply retention, to the TSDB blocks held inside, thus, making queries on historical data more efficient. It creates aggregates of old metrics (based upon the rules).

It is also responsible for downsampling of data, performing 5m downsampling after 40 hours, and 1h downsampling after 10 days.

If you want to know more about Thanos Compactor, jump here.

> Note: Thanos Compactor is mandatory if you use object storage otherwise Thanos Store Gateway will be too slow without using a compactor.

Deploying Thanos Compactor
Click below snippet to start the Compactor.
```sh
docker run -d --net=host --rm \
 -v /root/editor/bucket_storage.yaml:/etc/thanos/minio-bucket.yaml \
    --name thanos-compact \
    quay.io/thanos/thanos:v0.26.0 \
    compact \
    --wait --wait-interval 30s \
    --consistency-delay 0s \
    --objstore.config-file /etc/thanos/minio-bucket.yaml \
    --http-address 0.0.0.0:19095
```
The flag wait is used to make sure all compactions have been processed while --wait-interval is kept in 30s to perform all the compactions and downsampling very quickly. Also, this only works when when --wait flag is specified. Another flag --consistency-delay is basically used for buckets which are not consistent strongly. It is the minimum age of non-compacted blocks before they are being processed. Here, we kept the delay at 0s assuming the bucket is consistent.

Setup Verification
To check if compactor works fine, we can look at the Bucket View.

Now, if we click on the blocks, they will provide us all the metadata (Series, Samples, Resolution, Chunks, and many more things).

Compaction and Downsampling
When we query large historical data there are millions of samples that we need to go through which makes the queries slower and slower as we retrieve year's worth of data.

Thus, Thanos uses the technique called downsampling (a process of reducing the sampling rate of the signal) to keep the queries responsive, and no special configuration is required to perform this process.

The Compactor applies compaction to the bucket data and also completes the downsampling for historical data.

To expierience this, click on the Querier and insert metrics continuous_app_metric0 with 1 year time range of graph, and also, click on Enable Store Filtering.

Let's try querying Max 5m downsampling data, it uses 5m resolution and it will be faster than the raw data. Also, Downsampling is built on top of data, and never done on young data.

Unlimited Retention - Not Challenging anymore?
Having a long time metric retention for Prometheus was always involving lots of complexity, disk space, and manual work. With Thanos, you can make Prometheus almost stateless, while having most of the data in durable and cheap object storage.