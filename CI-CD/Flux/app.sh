#!/bin/sh

export GITHUB_TOKEN=<your-token>

flux bootstrap github \
  --owner=dipankardas011 \
  --repository=flux-repository \
  --path=local/rancher/cluster/dev \
  --personal

flux create source git react \
--url=<> \
--branch=main

flux create kustomization <> \
--target-namespace=app \
--source=react \
--path="" \
--prune=true \
--interval=5m