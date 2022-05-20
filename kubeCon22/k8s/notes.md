# K8s Networking 101

https://github.com/RX-M/kubecon-eu-2022/

we should use selector to automatic endpoints created

not microservices then headless

clusterIP for microservices
NodePort that port is reserved for us [from outside world]

LoadBalancer (NodePort + external loadbalancer) some plugin azurelB, GCPLB


CLuster IP(parent)

|
|
\/
Node POrt(derived)

|
|
\/
Load balancer(derived)
it chooses which node