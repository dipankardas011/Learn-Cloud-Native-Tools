#!/bin/bash

kubectl apply -k mysql/

# host1=$(echo $(kubectl describe node kind-control-plane | grep InternalIP) | awk '{print $2}')
NODEPORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services mysql-server -n mysql-ns)
NODES=$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }')
MASTERNODES=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
sleep 2
# echo $host1:31001
# curl $host1:31001
curl $MASTERNODES:$NODEPORT
curl $host1:31001


# for i in 2 3 4
# do
  # echo "172.18.0.$i:31001 -> "
  # curl 172.18.0.$i:31001
# done