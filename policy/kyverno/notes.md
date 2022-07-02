# Kubesimplify links

[Intro](https://kubesimplify.com/getting-started-with-kyverno)

[CLI](https://kubesimplify.com/kyverno-cli)

[It with cosign](https://kubesimplify.com/kyverno-and-cosign)

to delete all the policies

```sh
kubectl delete cpol --all
```

# Course from Kyverno
![](https://learn.nirmata.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJaWt5T1dNNFkyRmtOQzB3TVRCaExUUmlZelF0WWpoaE5pMWhObVJpTXpobU1XWTRZbVlHT2daRlZBPT0iLCJleHAiOm51bGwsInB1ciI6ImJsb2JfaWQifX0=--298902dc2966d947fad59c00f2a2d0042725e3e0/kyverno-architecture.png)


```sh
# to view the cluster policies
kubectl get cpol # clusterpolicy
```

audit => will create but will mark the policy as failed in policyreport
enforce => will not allow the resource to be created
```sh
kubectl get policyreport
kubectl describe policyreport polr-ns-default | grep "Status: " -B10
```

when the new network policy is generated
when we create a new namespace it will automatically create the **network policy**

```sh
kubectl get netpol -n demo
```
