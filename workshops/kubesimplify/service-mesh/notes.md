# Meshery


[WorkShop Links](https://layer5.io/learn/service-mesh-labs)

service mesh func
---
- traffic control
	- traffic splitting
	- traffic sterring
	- ingress and egress routing

- resilency
	- timeout
	- retries
	- circuit breakers
	- healthchecks

- observaility
- security
- business logic

traffic introspecition (what all is being send)


kubernetes
---
cluster management, scheduling, service discovery, networking and load balanceing
application secrets, deployments, rollouts, health and performance metrics


```sh
vi ~/.meshery/config.yaml
# OR
mesheryctl system context view
```

mesh sync - meshery is synced with kubernetes (any activity going on)

data plane = req and res send and recieved with different services (service proxy a.k.a. sidecar proxy) envoy
[heavy lifting]

Control plane = manages the confg of those proxies,

management plane = here meshery comes in


Major features control plane has in
---
discovery&confg | tls certs | policy check

