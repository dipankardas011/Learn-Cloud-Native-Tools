# From Gitops fundamentals

## Creating an ArgoCD application in the UI

Next, add the following to create the application:

General Section:

Application Name: TBD
Project: default
Sync Policy: Automatic


Source Section:

Repository URL/Git: this is the GitHub repository URL
Branches: main
Path: TBD

Destination Section:

Cluster URL: select the cluster URL you are using
Namespace: default

## Creating an Argo CD application with the argocd CLI

```sh
argocd app create {APP NAME} \
--project {PROJECT} \
--repo {GIT REPO} \
--path {APP FOLDER} \
--dest-namespace {NAMESPACE} \
--dest-server {SERVER URL}
```
* {APP NAME} is the name you want to give the application
* {PROJECT} is the name of the project created or "default"
* {GIT REPO} is the url of the git repository where the gitops config is located
* {APP FOLDER} is the path to the configuration for the application in the gitops repo
* {DEST NAMESPACE} is the target namespace in the cluster where the application will be deployed
* {SERVER URL} is the url of the cluster where the application will be deployed. Use https://kubernetes.default.svc to reference the same cluster where Argo CD has been deployed

```sh
argocd app list
# For a more detailed view of the application configuration, run:
argocd app get {APP NAME}
```

## Deploy
```sh
argocd app sync {APP NAME}
# This synchronizes the application. To confirm it’s running, you can execute a kubectl command.
kubectl -n {NAMESPACE} get all
```

## CLI
Argo CD CLI
Step 1
Apart from the UI, ArgoCD also has a CLI. We have installed already the cli for you and authenticated against the instance.

Try the following commands
```sh
argocd app list
argocd app get demo
argocd app history demo
```
Let's delete the application and deploy it again but from the CLI this time.

First delete the app
```sh
argocd app delete demo
```
Confirm the deletion by answering yes in the terminal. The application will disappear from the Argo CD dashboard after some minutes.

Now deploy it again.
```sh
argocd app create demo2 \
--project default \
--repo https://github.com/codefresh-contrib/gitops-certification-examples \
--path "./simple-app" \
--dest-namespace default \
--dest-server https://kubernetes.default.svc
The application will appear in the ArgoCD dashboard.
```
Now sync it with

argocd app sync demo2


## Reconcilation


You can change the default period by editing the argocd-cm configmap found on the same namespace as Argo CD.
```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
data:
  timeout.reconciliation: 240s
```
This example changes the sync period to 4 minutes. After you change the manifest, you need to redeploy the argocd-repo-server service

> You can disable the sync functionality completely by setting the timeout.reconciliation period to 0.

> And finally you can change the way Argo CD learns about Git changes, and instead of polling your Git provider, you can use Git webhooks or you can use webhooks in tandem with reconciliation. This way should the webhooks fail or you are operating within an environment behind a firewall - the webhook that cannot reach a deployment will continue as expected. The process is described in the official documentation page at [Link](https://argo-cd.readthedocs.io/en/stable/operator-manual/webhook/) and it is different according to your Git provider.

Using Webhooks is very efficient, as now your Argo CD installation will never delay when you commit something to Git. If you only use the default way of polling, then you might have to wait up to 3 minutes (or whatever time you have set as sync period) for Argo CD to detect the changes. With Webhooks, as soon as there is any change in Git, Argo CD will run the sync process.

## Application Health

The possible values are:

* **Healthy** -> Resource is 100% healthy
* **Progressing** -> Resource is not healthy but still has a chance to reach healthy state
* **Suspended** -> Resource is suspended or paused. The typical example is a cron job
* **Missing** -> Resource is not present in the cluster
* **Degraded** -> Resource status indicates failure or resource could not reach healthy state in time
* **Unknown** -> Health assessment failed and actual health status is unknown

For the built-in Kubernetes resources, the rules are the following:

* Deployments, ReplicaSets, StatefulSets, and Daemon sets are considered “healthy” if observed generation is equal to desired generation.
Number of updated replicas equals the number of desired replicas.

For a service of type Loadbalancer or Ingress, the resource is healthy if the status.loadBalancer.ingress list is non-empty, with at least one value for hostname or IP.

For custom Kubernetes resources, health is defined in Lua scripts. Some examples of resources that have custom health definitions are:
* Argo Rollout (and associated Analysis and Experiments)
* Bitnami Sealed secrets
* Cert Manager
* Elastic Search
* Jaeger
* Kafka
* CrossPlane provider

You can see a list of all custom health checks at https://github.com/argoproj/argo-cd/tree/master/resource_customizations. You can add your own health check for a custom resource by implementing the check in Lua which is a self-contained scripting language.

Here is a simple example of the health check from Argo Rollouts Experiments that simply maps the experiment status to Argo CD health status.

```lua
hs = {}
if obj.status ~= nil then
    if obj.status.phase == "Pending" then
        hs.status = "Progressing"
        hs.message = "Experiment is pending"
    end
    if obj.status.phase == "Running" then
        hs.status = "Progressing"
        hs.message = "Experiment is running"
    end
    if obj.status.phase == "Successful" then
        hs.status = "Healthy"
        hs.message = "Experiment is successful"
    end
    if obj.status.phase == "Failed" then
        hs.status = "Degraded"
        hs.message = "Experiment has failed"
    end
    if obj.status.phase == "Error" then
        hs.status = "Degraded"
        hs.message = "Experiment had an error"
    end
    return hs
end
hs.status = "Progressing"
hs.message = "Waiting for experiment to finish: status has not been reconciled."
return hs
```
You can write your own health check in a similar manner for your custom resource, if it is not already supported by Argo CD.

This means that you have several combinations of all the settings as shown in the following table:

Policy | A | B | C | D | E
-|-|-|-|-|--
Sync Strategy | Manual |	Auto | Auto | Auto | Auto
`Auto-prune` | N/A | Disabled | Enabled | Disabled | Enabled
`Self-heal` | N/A | Disabled | Disabled | Enabled |	Enabled

* Policy A (nothing is done by Argo CD) is probably how you should start adopting Argo CD , especially if you want to apply GitOps on an existing project. This is your chance to see how Argo CD works, without actually affecting your deployments.

* Policy B (auto-sync) is the first step towards following GitOps with its automation capabilities. As soon as any change happens in Git, your cluster will auto-update. Disabling `auto-prune` means that you must still delete resources manually, and disabled `self-heal` means that you can still make manual changes to the cluster (if you want to have a migration period).

* Policies C and D are orthogonal and can act as stepping stones to Policy E, which is the one you should look up to. 
Under that policy, everything is automated both ways. Changes in Git are also reflected automatically to the cluster (including removals of resources), and manual changes in the cluster are simply discarded.

Adopting GitOps in its purest form may require organizational changes or a reexamination of policies and your organization may not be ready at this point. While correcting drift automatically will help organizations get the most out of GitOps, it may take some time to be ready.

Self heal =>> is for removal of resources when deleted in git
Self prune =>> is used to discard any manual changes 
