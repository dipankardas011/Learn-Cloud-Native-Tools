# Node Affinity
If the pod containing some label matches a given node's label then it is scheduled to that node

# Taints & Tolerations
Taints - in Nodes
Tolerations - in Pods

If the pod doesnt contains any tolerations then it is not scheduled in node which does have a taints (Not Guranteed)
If the tains matches with the toleration of pod its scheduled(DONE)
If doent match then also it can be 

!!TODO