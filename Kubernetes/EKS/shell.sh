#!/bin/bash

eksctl create cluster \
	--name test-cluster \
	--region us-east-1 \
	--nodegroup-name linux-nodes \
	--node-type t2.micro \
	--nodes 2

