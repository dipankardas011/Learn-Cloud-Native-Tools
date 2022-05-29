# Node Affinity
If the pod containing some label matches a given node's label then it is scheduled to that node
> Node affinity is a property of pods that attracts to a set of nodes(either as a preference or a hard requirement). 

> Taints are the opposite-they allow a node to repel a set of pods

where your pods can be scheduled based on labels of nodes

- requiredDuringSchedulingIgnoredDuringExecution(HARD)
  * if the pod is already running in the unlabeled node then it is deleted
- preferedDuringSchedulingIgnoredDuringExecution(SOFT)
  * if the pod is already running in the unlabelled node then it is not deleted

affinity.yaml

here we want a pod to be scheduled to a particular node


# Taints & Tolerations
Taints applyed to Nodes
{key:=value and effect} is set in the node
Tolerations - in Pods

If the pod doesnt contains any tolerations then it is not scheduled in node which does have a taints (Not Guranteed)
If the tains matches with the toleration of pod its scheduled(DONE)
If doent match then also it can be 

if the pod is having toleration
```yml
# pod
key: "foo"
operator: "Equal" # Exist / Equal
# for Exist no value is required
value: "bar"
effect: "NoSchedule" # NoSchedule / PreferNoSchedule / NoExecute
```
here the taints is matching with the toleration in pod
this pod *can* be scheduled

we are just telling node to only accept the pods with the given toleratos to this particular taints if not do not accept
if the pod does not has the same taints which matches the tolerations then it should not be scheduled
it can also go to some other node where no taints is mentioned
here we are restricting the pod to be schedule on the node

in affinity we are telling the pod to run on the particular node

## Effect
1. NoSchedule - do not schedule the pod which do not have tolerations for this taints
2. PreferNotSchedule - try not to schedule the pods which do not have tolerations for this taints
3. NoExecute - (#1.) + Pod eviction - 
if node does not has the taints in first place then there are some scheduled pods
if after appliying #3. it removed the pods which dont match the tolerations and taints even if they where scheduled in the first place

## Use cases
* Dedicated nodes
* Special HardwareS
* Taint based Executions - noExecute taints

`toleratioSeconds` for this time it will be alive even if NoExecute is allpyed 

# Demo

```bash
# to view all the Taints of all nodes
kubectl describe nodes | grep Taint

# tainting a node
kubectl taint node <node_name> key=value:effect


# untaint the node we put '-'
kubectl taint node <node_name> key=value:effect-


```