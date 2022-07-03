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

## Managing Secrets

Encrypting your secrets
We have seen how the controller decrypts secrets. But how do we encrypt secrets in the first place? The controller comes with the associated kubeseal executable that is created for this purpose.

It is a single binary, so you can install it by copying it to your favorite directory (probably in your PATH variable).

Download the latest sealed secrets for your distribution from: https://github.com/bitnami-labs/sealed-secrets/releases

And install by following these directions:
https://github.com/bitnami-labs/sealed-secrets/blob/main/README.md#installation

Kubeseal does the opposite operation from the controller. It takes an existing Kubernetes secret and encrypts it. Kubeseal requests the public key that was created during the installation process from the cluster and encrypts all secrets with that key.

This means that:

Kubeseal needs access to the cluster in order to encrypt secrets. (It expects a kubeconfig like kubectl.)
Encrypted secrets can only be used in the cluster that was used for the encryption process.

The last point is very important as it means that all secrets are cluster specific.
The namespace of the application is also used by default, so secrets are cluster and namespace specific.

If you want to use the same secret for different clusters, you need to encrypt it for each cluster individually.

```sh
# To use kubeseal, just take any existing secret in yaml or json format and encrypt it:
kubeseal -n my-namespace <.db-creds.yml> db-creds.json
# This creates a SealedSecret which is a custom Kubernetes resource specific to the controller. This file is safe to commit in Git or store in another external system.
# You can then apply the secret on the cluster:
kubectl apply -f db-creds.json -n my-namespace
```
The secret is now part of the cluster and will be decrypted by the controller when an application needs it.

Here is the full diagram of encryption/decryption:

![](Screenshot%20from%202022-07-03%2013-30-26.png)

The full process is the following:

You create a plain Kubernetes secret locally. You should never commit this anywhere.
You use kubeseal to encrypt the secret in a SealedSecret.
You delete the original secret from your workstation and apply the sealed secret to the cluster.
You can optionally commit the Sealed secret to Git.
You deploy your application that expects normal Kubernetes secrets to function. (The application needs no modifications of any kind.)
The controller decrypts the Sealed secrets and passes them to your application as plain secrets.
The application works as usual.
By using the Sealed Secrets controller, we can finally store all our secrets in Git (in an encrypted form) right along the application configuration.

### Lab

```sh
# argocd
https://github.com/dipankardas011/gitops-certification-examples/bitnami-sealed-controller
```

### Use Kubeseal to encrypt secrets
The Sealed Secrets controller is running now on the cluster and it is ready to decrypt secrets.

We now need to encrypt our secrets and commit them to git. Encryption happens with the kubeseal executable. It needs to be installed in the same way as kubectl. It re-uses the cluster authentication already used by kubectl.

We have already installed kubeseal for you in this exercise. You can use it right away to encrypt your plain Kubernetes secrets and convert them to encrypted secrets

Run the following
```sh
kubeseal < unsealed_secrets/db-creds.yml > sealed_secrets/db-creds-encrypted.yaml -o yaml
kubeseal < unsealed_secrets/paypal-cert.yml > sealed_secrets/paypal-cert-encrypted.yaml -o yaml
```
Now you have encrypted secrets. Open the files in the "Editor" tab and copy the contents in your clipboard.

Then go the Github UI in another browser tab and commit/push their contents in your own fork of the application, filling the empty files at `gitops-certification-examples/secret-app/manifests/db-creds-encrypted.yaml` and `gitops-certification-examples/secret-app/manifests/paypal-cert-encrypted.yaml`

Once you are ready to proceed, press Check.


Deploy secrets
Step 1
Now that all our secrets are in Git in an encrypted form we can deploy our application as normal.

Login in the Argo CD UI.

Click the "New app" button on the top left and fill the following details:

application name : demo
project: default
SYNC POLICY: automatic
repository URL: https://github.com/your_github_account/gitops-certification-examples
path: ./secret-app/manifests
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: default
Leave all the other values empty or with default selections. Finally click the Create button. The application entry will appear in the main dashboard. Click on it.

The application should now be deployed. Once it is healthy you can see it running in the "Deployed app" tab. Just for illustration purposes, the application is showing the secrets it can access. This way you can verify that the sealed secrets controller is working as expected, decrypting secrets on the fly.


##### Argo 1
```yml
project: default
source:
  repoURL: 'https://github.com/dipankardas011/gitops-certification-examples/'
  path: ./bitnami-sealed-controller
  targetRevision: HEAD
destination:
  server: 'https://kubernetes.default.svc'
  namespace: kube-system
syncPolicy:
  automated: {}
```

##### Argo 2
```yml
project: default
source:
  repoURL: 'https://github.com/dipankardas011/gitops-certification-examples'
  path: ./secret-app/manifests
  targetRevision: HEAD
destination:
  server: 'https://kubernetes.default.svc'
  namespace: default
syncPolicy:
  automated: {}
```


Use App of Apps
We can delete the application like any other Kubernetes resource

kubectl delete -f my-application.yml
After a while the application should disappear from the ArgoCD UI.

Remember however that the whole point of GitOps is to avoid manual kubectl commands. We want to store this application manifest in Git. And if we store it in Git, we can handle it like another GitOps application!

ArgoCD can manage any kind of Kubernetes resources and this includes its own applications (inception).

So we can commit multiple applications in Git and pass them to ArgoCD like any other kind of manifest. This means that we can handle multiple applications as a single one.

We already have such example at https://github.com/codefresh-contrib/gitops-certification-examples/tree/main/declarative/multiple-apps.

In the ArgoCD UI, click the "New app" button on the top left and fill the following details:

application name : 3-apps
project: default
SYNC POLICY: automatic
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./declarative/multiple-apps
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: argocd
Notice that the namespace value is the namespace where the parent Application is deployed and not the namespace where the individual applications are deployed. ArgoCD applications must be deployed in the same namespace as ArgoCD itself.

Leave all the other values empty or with default selections. Finally click the Create button.

ArgoCD will deploy the parent application and its 3 children. Click on the parent application. You should see the following.three-apps

Spend some time on the UI to understand where each application is deployed. You can also use the command line
```sh
kubectl get all -n demo1
kubectl get all -n demo2
kubectl get all -n demo3
```
Once you are ready to finish the track, press Check.


### Helm
Something important to note is that Argo CD provides native support for Helm, meaning you can directly connect a packaged Helm chart and Argo CD will monitor it for new versions. When this takes place, the Helm chart will no longer function as a Helm chart and instead, is rendered with the Helm template when Argo is installed, using the Argo CD application manifest.

Argo CD then deploys and monitors the application components until both states are identical. The application is no longer a Helm application and is now recognized as an Argo app that can only operated by Argo CD. Hence if you execute the helm list command, you should no longer be able to view your helm release because the Helm metadata no longer exists.

Here’s an example of the command output. As you can see, the Argo CD application is NOT detected as a Helm application:

```
root@kubernetes-vm:~/workdir#
root@kubernetes-vm:~/workdir# argocd app list
NAME                 CLUSTER                         NAMESPACE  PROJECT  STATUS  HEALTH   SYNCPOLICY  CONDITIONS  REPO                                                                PATH         TARGET
helm-gitops-example  https://kubernetes.default.svc  default    default  Synced  Healthy  Auto        <none>      https://github.com/codefresh-contrib/gitops-certification-examples  ./helm-app/  HEAD
root@kubernetes-vm:~/workdir# argocd app get helm-gitops-example
Name:               helm-gitops-example
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          default
URL:                https://localhost:30443/applications/helm-gitops-example
Repo:               https://github.com/codefresh-contrib/gitops-certification-examples
Target:             HEAD
Path:               ./helm-app/
SyncWindow:         Sync Allowed
Sync Policy:        Automated
Sync Status:        Synced to HEAD (381ec55)
Health Status:      Healthy

GROUP  KIND            NAMESPACE  NAME                              STATUS  HEALTH   HOOK  MESSAGE
       ServiceAccount  default    helm-gitops-example-helm-example  Synced                 serviceaccount/helm-gitops-example-helm-example created
       Service         default    helm-gitops-example-helm-example  Synced  Healthy        service/helm-gitops-example-helm-example created
apps   Deployment      default    helm-gitops-example-helm-example  Synced  Healthy        deployment.apps/helm-gitops-example-helm-example created
root@kubernetes-vm:~/workdir# argocd app history helm-gitops-example
ID  DATE                           REVISION
0   2022-07-03 10:10:41 +0000 UTC  HEAD (381ec55)
root@kubernetes-vm:~/workdir# argocd app delete helm-gitops-example
Are you sure you want to delete 'helm-gitops-example' and all its resources? [y/n]
y
root@kubernetes-vm:~/workdir # argocd app create demo \
> --project default \
> --repo https://github.com/codefresh-contrib/gitops-certification-examples \
> --path "./helm-app/" \
> --sync-policy auto \
> --dest-namespace default \
> --dest-server https://kubernetes.default.svc
application 'demo' created
```

### Kustomize
Using ArgoCD CLI
Step 1
Apart from the UI, ArgoCD also has a CLI. We have installed already the cli for you and authenticated against the instance.

Try the following commands
```sh
argocd app list
argocd app get kustomize-gitops-example
argocd app history kustomize-gitops-example
```
Let's delete the application and deploy it again but from the CLI this time.

First delete the app
```sh
argocd app delete kustomize-gitops-example
```
Confirm the deletion by answering yes in the terminal. The application will disappear from the Argo CD dashboard after some minutes.

Now deploy it again.
```sh
argocd app create demo \
--project default \
--repo https://github.com/codefresh-contrib/gitops-certification-examples \
--path ./kustomize-app/overlays/staging \
--sync-policy auto \
--dest-namespace default \
--dest-server https://kubernetes.default.svc
```
The application will appear in the ArgoCD dashboard.
Confirm the deployment

kubectl get all
Finish
If you've confirmed the deployment, click Check to finish this track.

## What is Progressive Delivery
Progressive Delivery is the practice of deploying an application in a gradual manner allowing for minimum downtime and easy rollbacks. There are several forms of progressive delivery such as blue/green, canary, a/b and feature flags.

##### Blue Green Deployments
Blue/Green deployments are one of the simplest ways to minimize deployment downtime. Blue/Green deployments are not specific to Kubernetes and can be used even for traditional applications that reside on Virtual Machines.


In the beginning, all users of the application are routed to the current version (shown as blue color). A key point is that all traffic passes from a load balancer
A new version is deployed (shown as green color). This version does not receive any live traffic so all users are still served by the previous/stable version
Developers can internally test the new color and verify its correctness. If it is valid, traffic is switched to that new version
If everything goes well, the old version is discarded completely. We are back to the initial state (and order of colors does not matter).

The major benefit of this pattern is that if at any point in time the new version has issues, all users can be switched back to the previous version (via the load balancer). Switching the load balancer is much faster than redeploying a new version, resulting in minimum disruption for existing users.
![](https://lwfiles.mycourse.app/codefresh-public/ff4771b79c5a0bc075a76b1503706b71.png)
There are several variations of this pattern. In some cases, the old color is never destroyed but keeps running in the background. You can also keep even older versions online (maybe with a smaller footprint) allowing for easy switching to any previous application revision.
##### Canary Deployments
Blue/Green deployments are great for minimizing downtime after a deployment, but they are not perfect. If your new version has a hidden issue that manifests itself only after some time (i.e. it is not detected by your smoke tests), then all your users will be affected because the traffic switch is all or nothing.

An improved deployment method is canary deployments. This functions similar to blue/green, but instead of switching 100% of live traffic all at once to the new version, you can instead move only a subset of users.
![](https://lwfiles.mycourse.app/codefresh-public/2acbf73ec0289f02aa417d0715a3c863.png)
In the beginning, all users of the application are routed to the current version (shown as blue color). A key point is that all traffic passes from a load balancer.
A new version is deployed (shown as green color). This version gets only a very small amount of live traffic (for example 10%).
Developers can test internally and monitor their metrics to verify the new release. If they are confident, they can redirect more traffic to the new version (for example 33%).
If everything goes well, the old version is discarded completely. All traffic is now redirected to the new version. We are back to the initial state (and order of colors does not matter).
The major benefit of this pattern is that if at any point in time the new version has issues, only a small subset of live users are affected. And like blue/green deployments, performing a rollback is as easy as resetting the load balancer to send no traffic to the canary version. Switching the load balancer is much faster than redeploying a new version, resulting in minimum disruption for existing users.
There are several variations of this pattern. The amount of live traffic that you send to the canary at each step as well as the number of steps are user configurable. A simple approach would have just two steps (10%, 100%) while a more complex one could move traffic in a gradual way (10%, 30%, 60%, 90%, 100%).

Note that canary deployments are more advanced than blue/green ones and are also more complex to set up. The load balancer is now much smarter as it can handle two streams of traffic at the same time with different destinations of different weights. You also need a way (usually an API) to instruct the load balancer to change the weight distribution of the traffic streams. If you are just getting started with progressive delivery, we suggest you master blue/green deployments first, before adopting canary ones.


## Argo Rollouts

Argo Rollouts is a progressive delivery controller created for Kubernetes. It allows you to deploy your application with minimal/zero downtime by adopting a gradual way of deploying instead of taking an “all at once” approach.

Argo Rollouts supercharges your Kubernetes cluster and in addition to the rolling updates you can now do:

Blue/green deployments
Canary deployments
A/B tests
Automatic rollbacks
Integrated Metric analysis

Let’s see how this works in practice.


## Blue/Green with Argo Rollouts
Even though Argo Rollouts supports the basic blue/green pattern described in the previous section, it also offers a wealth of customization options. One of the most important additions is the ability to “test” the upcoming color by introducing a “preview” Kubernetes service, in addition to the service used for live traffic. This preview service can be used by the team that performs the deployment to verify the new version before actually switching the traffic.

Here is the initial state of a deployment. The example uses 2 pods (shown as xnsdx and jftql in the diagram).
![](https://lwfiles.mycourse.app/codefresh-public/32de033e682be0ae965a7ffa4191ac4c.png)

There are two Kubernetes services. The rollout-blue-green-active is capturing all live traffic from actual users of the application (internet traffic coming from 52.141.221.40). There is also a secondary service called rollout-bluegreen-preview. Under normal circumstances, it also points to the same live version.

Once a deployment starts, a new “color” is created. In the example we have 2 new pods that represent the next version of the application to be deployed (shown as 9t67t and 7vs2m).
![](https://lwfiles.mycourse.app/codefresh-public/1a511fdd73a7cfb1d2f761c90be69843.png)
The important point here is the fact that the normal “active” service still points to the old version while the “preview” service points to the new pods. This means that all active users are still on the old/stable deployment while internal teams can use the “preview” service to test the new deployment.

If everything goes well, the next version is promoted to be the active version.

![](https://lwfiles.mycourse.app/codefresh-public/7f2fe152782b2e6860dd62932679f6e6.png)
Here both services point to the new version. This is also the critical moment for all real users of the application, as they are now switched to use the new version of the application. The old version is still around, but no traffic is sent to it.

Having the old version around is a great failsafe, as one can abort the deployment process and switch back all active users to the old deployment in the fastest way possible.
![](https://lwfiles.mycourse.app/codefresh-public/27012104f0fbbcc1f5c4fafcacb131ff.png)
After some time (the exact amount is configurable in Argo Rollouts), the old version is scaled down completely (to preserve resources). We are now back to the same configuration as the initial state, and the next deployment will follow the same sequence of events.

## Install the Argo Rollouts controller
Before we get started with progressive delivery we need to install the Argo Rollouts controller on the cluster.

We installed Argo CD for you and you can login in the UI tab.

The UI starts empty because nothing is deployed on our cluster. Click the "New app" button on the top left and fill the following details:

application name : argo-rollouts-controller
project: default
SYNC POLICY: automatic
AUTO-CREATE Namespace: enabled
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./argo-rollouts-controller
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: argo-rollouts
Leave all the other values empty or with default selections. Finally click the Create button. The controller will be installed on the cluster.

Notice that we are not using the default namespace, but a brand new one. It is imperative that you select the "auto-create namespace" option.

auto-create

If you don't select this option, ArgoCD will not find the namespace and deployment will fail. Delete the application and create it again if you have a deployment issue.

You can also manually do if you forgot it in the UI:

kubectl create namespace argo-rollouts
Try syncing again the application.

You can see that GitOps is not only useful for your own applications but also for other supporting applications as well.

Wait some time until the controller is fully synced and the deployment is marked as Healthy.

The first deployment
The Argo Rollouts controller is running now on the cluster and it is ready to handle deployments.

Lets deploy our application. Since this is the first deployment, there is no previous version and thus a normal deployment will take place.

We installed Argo CD for you and you can login in the UI tab.

Click the "New app" button on the top left and fill the following details

application name : demo
project: default
SYNC POLICY: Manual
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./blue-green-app
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: default
Leave all the other values empty or with default selections.

Finally click the Create button. The application entry will appear in the main dashboard. Click on it.

The application will be initially "Out of Sync". Press the sync button to sync it and wait until it is healthy.

The application is deployed and you can see it in the "Live traffic" tab. You should see the following.

version1

Argo Rollouts also has an optional CLI that can be used for monitoring and promoting deployments

We have already installed kubectl argo rollouts for you in this exercise. And we can use it to monitor the first deployment

Run the following
```sh
kubectl argo rollouts list rollouts
kubectl argo rollouts status simple-rollout
kubectl argo rollouts get rollout simple-rollout
```
The last command shows the status of the rollout. Since this is the first version there is only one replicaset with two pods.

You can also see this with

kubectl get rs
Once you are ready to proceed, press Check.


The first deployment
The Argo Rollouts controller is running now on the cluster and it is ready to handle deployments.

Lets deploy our application. Since this is the first deployment, there is no previous version and thus a normal deployment will take place.

We installed Argo CD for you and you can login in the UI tab.

Click the "New app" button on the top left and fill the following details

application name : demo
project: default
SYNC POLICY: Manual
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./blue-green-app
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: default
Leave all the other values empty or with default selections.

Finally click the Create button. The application entry will appear in the main dashboard. Click on it.

The application will be initially "Out of Sync". Press the sync button to sync it and wait until it is healthy.

The application is deployed and you can see it in the "Live traffic" tab. You should see the following.

version1

Argo Rollouts also has an optional CLI that can be used for monitoring and promoting deployments

We have already installed kubectl argo rollouts for you in this exercise. And we can use it to monitor the first deployment

Run the following
```sh
kubectl argo rollouts list rollouts
kubectl argo rollouts status simple-rollout
kubectl argo rollouts get rollout simple-rollout
```
The last command shows the status of the rollout. Since this is the first version there is only one replicaset with two pods.

You can also see this with

kubectl get rs
Once you are ready to proceed, press Check.




## Blue/Green deployments
We are now ready to have a blue/Green deployment with the next version.

Change the container image of the rollout to the next version with:
```sh
kubectl argo rollouts set image simple-rollout webserver-simple=docker.io/kostiscodefresh/gitops-canary-app:v2.0
```
We are using kubectl just for illustration purposes. Normally you should follow the GitOps principles and perform a commit to the Git repo of the application. But just for this exercise we will do all actions manually so that you have time to see what happens.

Enter the following to see what Argo Rollouts is doing behind the scenes
```sh
kubectl argo rollouts get rollout simple-rollout
```
After you change the image the following things happen

Argo Rollouts creates another replicaset with the new version
The old version is still there and gets live/active traffic
ArgoCD will mark the application as out-of-sync
ArgoCD will also mark the health of the application as "suspended" because we have setup the new color to wait
Notice that even though the next version of our application is already deployed, all live traffic goes to the old version. You can verify this by looking at the "live traffic" tab.

At this point the deployment is suspended because we have used the autoPromotionEnabled: false property in the definition of the rollout.

To manually promote the deployment and switch all traffic to the new version enter:
```sh
kubectl argo rollouts promote simple-rollout
```
Then monitor again the rollout with
```sh
kubectl argo rollouts get rollout simple-rollout --watch
```
After a while you should see the pods of the old version getting destroyed.


## Canaries with Argo Rollouts
Argo Rollouts supports the basic canary pattern described in the previous section, and also offers a wealth of customization options. One of the most important additions is the ability to “test” the upcoming version by introducing a “preview” Kubernetes service, in addition to the service used for live traffic. This preview service can be used by the team that performs the deployment to verify the new version as it gets used by the subset of live users.

Here is the initial state of a deployment. The example uses 4 pods (shown as 22nqx, nqksq, 8bzwh and jtdcc in the diagram).

There are now three Kubernetes services. The rollout-canary-all-traffic service is capturing all live traffic from actual users of the application (internet traffic coming from 20.37.135.240). There is a secondary service called rollout-canary-active. This will always point to the stable/previous version of the software. Finally the third service is called rollout-canary-preview, and this will only route traffic to the canary/new versions. Under normal circumstances all 3 services point to the same version.

Once a deployment starts, a new “version” is created. In the example we have 1 new pod that represents the next version of the application to be deployed (shown as 9wx8w at the top of the diagram).
![](https://lwfiles.mycourse.app/codefresh-public/6f68ef344282a66847d474de69eaf951.png)
The important point here is the fact that the service used by live users (called rollout-canary-all-traffic) is routing traffic to both the canary and the previous version. It is not visible in the diagram, but only 10% of traffic is sent to the single pod that hosts the new version, while 90% of traffic goes to the 4 pods of the old version.

![](https://lwfiles.mycourse.app/codefresh-public/8fa31fd54fb3427301bce4f0f3c1f9b2.png)
The rollout-canary-preview service goes only to the canary pod. You can use this service to examine metrics from the canary or even give it to users that always want to try the new version first (e.g. your internal developers). On the other hand, the rollout-canary-active service always goes to the stable version. You can use that for users who never want to try the new version first or for verifying how something worked in the previous version.

If everything goes well, and you are happy with how the canary works, we can redirect some more traffic to it.
![](https://lwfiles.mycourse.app/codefresh-public/b77a8baf0569b53be3357c6f6c9d5efc.png)
We are now sending 33% of live traffic to the canary (the traffic weights are not visible in the picture). To accommodate for the extra traffic, the canary version now has 2 pods instead of one. This is also another great feature of Argo Rollouts. The amount of pods you have in the canary is completely unrelated to the amount of traffic that you send to it. You can have all possible combinations that you can think of (e.g. 10% of traffic to 5 pods, or 50% of traffic to 3 pods and so on). It all depends on the resources used by your application.
![](https://lwfiles.mycourse.app/codefresh-public/9a73456a2c6a6e6b5078b018b12b3174.png)
It makes sense of course to gradually increase the number of pods in the canary as you shift more traffic to it.

Having the old version around is a great failsafe, as one can abort the deployment process and switch back all active users to the old deployment in the fastest way possible by simply telling the load balancer to move 100% of traffic back to the previous version.

Two more pods are launched for the canary (for a total of 4), and finally we can shift 100% of live traffic to it. After some time, the old version is scaled down completely (to preserve resources). We are now back to the same configuration as the initial state, and the next deployment will follow the same sequence of events.




## Install the Argo Rollouts controller
Before we get started with progressive delivery we need to install the Argo Rollouts controller on the cluster.

We installed Argo CD for you and you can login in the UI tab.

The UI starts empty because nothing is deployed on our cluster. Click the "New app" button on the top left and fill the following details:

application name : argo-rollouts-controller
project: default
SYNC POLICY: automatic
AUTO-CREATE Namespace: enabled
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./argo-rollouts-controller
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: argo-rollouts
Leave all the other values empty or with default selections. Finally click the Create button. The controller will be installed on the cluster.

Notice that we are not using the default namespace, but a brand new one. It is imperative that you select the "auto-create namespace" option.

auto-create

If you don't select this option, ArgoCD will not find the namespace and deployment will fail. Delete the application and create it again if you have a deployment issue.

You can also manually do if you forgot it in the UI:

kubectl create namespace argo-rollouts
Try syncing again the application.

You can see that GitOps is not only useful for your own applications but also for other supporting applications as well.

Wait some time until the controller is fully synced and the deployment is marked as Healthy.

## Install Ambassador
Blue/Green deployments can work on any vanilla Kubernetes cluster. But for Canary deployments you need a smart service layer that can gradually shift traffic to the canary pods while still keeping the rest of the traffic to the old/stable pods.

Argo Rollouts supports several service meshes and gateways for this purpose.

In this lesson we will use the popular Ambassador API Gateway for Kubernetes to split live traffic between the canary and old/stable version.

We installed Argo CD for you and you can login in the UI tab.

Click the "New app" button on the top left and fill the following details:

application name : ambassador
project: default
SYNC POLICY: automatic
AUTO-CREATE Namespace: enabled
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./ambassador-chart
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: ambassador
Leave all the other values empty or with default selections. Finally click the Create button. The Ambassador Gateway will be installed on the cluster.

Notice that we are not using the default namespace, but a brand new one. It is imperative that you select the "auto-create namespace" option.

auto-create

If you don't select this option, ArgoCD will not find the namespace and deployment will fail. Delete the application and create it again if you have a deployment issue.

You can also manually do if you forgot it in the UI:

kubectl create namespace ambassador
Try syncing again the application.

Again, you can see that GitOps is not only useful for your own applications but also for other supporting applications as well.

Wait some time until the gateway is fully synced and the deployment is marked as Healthy.

## The first deployment
The Argo Rollouts controller is running now on the cluster and it is ready to handle deployments.

Lets deploy our application. Since this is the first deployment, there is no previous version and thus a normal deployment will take place.

We installed Argo CD for you and you can login in the UI tab.

Click the "New app" button on the top left and fill the following details

application name : demo
project: default
SYNC POLICY: Manual
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./canary-app
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: default
Leave all the other values empty or with default selections.

Finally click the Create button. The application entry will appear in the main dashboard. Click on it.

The application will be initially "Out of Sync". Press the sync button to sync it and wait until it is healthy.

The application is deployed and you can see it in the "Live traffic" tab. You should see the following.

version1

Argo Rollouts also has an optional CLI that can be used for monitoring and promoting deployments

We have already installed kubectl argo rollouts for you in this exercise. And we can use it to monitor the first deployment

Run the following
```sh
kubectl argo rollouts list rollouts
kubectl argo rollouts status simple-rollout
kubectl argo rollouts get rollout simple-rollout
```
The last command shows the status of the rollout. Since this is the first version there is only one replicaset with ten pods.

You can also see this with

kubectl get rs
Once you are ready to proceed, press Check.


## Canary deployments
We are now ready to have a Canary deployment with the next version.

Change the container image of the rollout to the next version with:

kubectl argo rollouts set image simple-rollout webserver-simple=docker.io/kostiscodefresh/gitops-canary-app:v2.0
We are using kubectl just for illustration purposes. Normally you should follow the GitOps principles and perform a commit to the Git repo of the application. But just for this exercise we will do all actions manually so that you have time to see what happens.

Enter the following to see what Argo Rollouts is doing behind the scenes

kubectl argo rollouts get rollout simple-rollout
After you change the image the following things happen

![](https://raw.githubusercontent.com/codefresh-contrib/gitops-certification-examples/main/pictures/canary.png)

Argo Rollouts creates another replicaset with the new version
The old version is still there and gets live/active traffic
The canary version gets 30% of the live traffic.
ArgoCD will mark the application as out-of-sync
ArgoCD will also mark the health of the application as "suspended" because we have setup the new color to wait
Notice that even though the next version of our application is already deployed, live traffic goes to both new/old versions. You can verify this by looking at the "live traffic" tab.

version1

At this point the deployment is suspended because we have used the pause properties in the definition of the rollout.

To manually promote the deployment and switch 60% to the new version enter:
```sh
kubectl argo rollouts promote simple-rollout
```
Then monitor again the rollout with
```sh
kubectl argo rollouts get rollout simple-rollout --watch
```
Repeat the same process three more time to send 100% to the canary version. Notice that at each step you can also look at the "stable" and "unstable" tabs and you can see that you can keep both old and new versions in play. This is useful if for some reason you have other applications in the cluster that always need to be pointed to the old or new version while a canary is in progress.

![](https://raw.githubusercontent.com/codefresh-contrib/gitops-certification-examples/main/pictures/version2.png)

After a while you should see the pods of the old version getting destroyed.

Now all live traffic goes to the new version as can be seen from the "live traffic" tab.

version1

The deployment has finished successfully now.

Finish
Once you are ready to finish the track, press Check.


##  Automated Rollbacks with Metrics
While you can use canaries with simple pauses between the different stages, Argo Rollouts offers the powerful capability to look at application metrics and decide automatically if the deployment should continue or not.

The idea behind this approach is to completely automate canary deployments. Instead of having a human running manual smoke tests, or looking at graphs, you can set different thresholds that define if a deployment is “successful” or not.

Here is the flow of the whole process:

Argo Rollouts already supports several metric providers such as Prometheus, DataDog, NewRelic, Cloudwatch, etc.

It is also possible to use a custom URL instead of a metric provider that will decide if a deployment should continue or not.

To take advantage of metric evaluation, Argo Rollouts introduces the concept of Analysis. An Analysis is deployed along with your Rollout and defines the thresholds for metrics.

Here is an example:
```yml
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: success-rate
spec:
  args:
  - name: service-name
  metrics:
  - name: success-rate
    interval: 2m
    count: 2
    # NOTE: prometheus queries return results in the form of a vector.
    # So it is common to access the index 0 of the returned array to obtain the value
    successCondition: result[0] >= 0.95
    provider:
      prometheus:
        address: http://prom-release-prometheus-server.prom.svc.cluster.local:80
        query: sum(response_status{app="{{args.service-name}}",role="canary",status=~"2.*"})/sum(response_status{app="{{args.service-name}}",role="canary"}
```
This prometheus analysis says that :
A metric of response status (200 responses vs total) will be fetched for Prometheus.
If this results in more than 0.95, the deployment will continue with success.
If the result is less than 0.95, then the canary will fail and the whole deployment will be rolled back automatically.


## Using Argo Rollouts & Argo CD
Argo Rollouts is an independent project that can work on its own. It also works great with Argo CD. Argo Rollouts will react to any manifest change regardless of how the manifest was changed. The manifest can be changed by a Git commit, an API call, another controller, or even a manual kubectl command. In the case of Argo CD, all changes to the cluster should happen via Git commits.

You can create an Argo Rollout application in Argo CD via all the ways already described in the previous section.

For example, you can create an Argo Rollout application declaratively with the following Argo CD application:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: canary-demo
spec:
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: demo
  project: default
  source:
    repoURL: 'https://github.com/kostis-codefresh/summer-of-k8s-app-manifests'
    path: ./
    targetRevision: HEAD
```
We have already talked about how Argo CD supports health status for several custom Kubernetes resources, and Argo Rollouts is one of them. This means:

Argo CD will correctly handle Argo Rollouts as Argo CD “applications”.
Argo CD will show up Argo Rollouts applications (in UI and CLI ) with the appropriate health status.
A paused Argo Rollout will show up as “suspended” in the ArgoCD.
The Argo CD UI also integrates some parts of the Argo Rollouts UI, so you can see the rollout status from within Argo CD UI

Other than that, both Argo Rollouts and Argo CD can work fine on their own. You don’t need to install Argo CD in order to use Argo Rollouts (a very common misconception).

## welcome
Make sure to fork it to your own account and note down the URL. It should be something like:

https://github.com/<your user>/gitops-certification-examples/

It is a very simple application with one deployment and one service. Notice that the deployment has been converted to a Rollout and has an extra section about the canary deployment options. It also has timed stages with the following pattern:

30% of traffic will be sent to the canary
After 2 minutes the canary will get 60% of traffic
After 2 more minutes 100% of the traffic will be sent to the canary

## Install the Argo Rollouts controller
Before we get started with progressive delivery we need to install the Argo Rollouts controller on the cluster.

We installed Argo CD for you and you can login in the UI tab.

The UI starts empty because nothing is deployed on our cluster. Click the "New app" button on the top left and fill the following details:

application name : argo-rollouts-controller
project: default
SYNC POLICY: automatic
AUTO-CREATE Namespace: enabled
repository URL: https://github.com/codefresh-contrib/gitops-certification-examples
path: ./argo-rollouts-controller
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: argo-rollouts
Leave all the other values empty or with default selections. Finally click the Create button. The controller will be installed on the cluster.

Notice that we are not using the default namespace, but a brand new one. It is imperative that you select the "auto-create namespace" option.

auto-create

If you don't select this option, ArgoCD will not find the namespace and deployment will fail. Delete the application and create it again if you have a deployment issue.


## Ambassador install



## The first deployment
The Argo Rollouts controller is running now on the cluster and it is ready to handle deployments.

Lets deploy our application. Since this is the first deployment, there is no previous version and thus a normal deployment will take place.

We installed Argo CD for you and you can login in the UI tab.

Click the "New app" button on the top left and fill the following details

application name : demo
project: default
SYNC POLICY: Manual
repository URL: https://github.com/<your user>/gitops-certification-examples
path: ./canary-app-timed
Cluster: https://kubernetes.default.svc (this is the same cluster where ArgoCD is installed)
Namespace: default
Leave all the other values empty or with default selections.

Finally click the Create button. The application entry will appear in the main dashboard. Click on it.

The application will be initially "Out of Sync". Press the sync button to sync it and wait until it is healthy.

The application is deployed and you can see it in the "Live traffic" tab. You should see the following.

version1

Argo Rollouts also has an optional CLI that can be used for monitoring and promoting deployments

We have already installed kubectl argo rollouts for you in this exercise. And we can use it to monitor the first deployment

Run the following
```sh
kubectl argo rollouts list rollouts
kubectl argo rollouts status simple-rollout
kubectl argo rollouts get rollout simple-rollout
```
The last command shows the status of the rollout. Since this is the first version there is only one replicaset with ten pods.

You can also see this with
```sh
kubectl get rs
```

## Canary deployments with GitOps
We are now ready to have a Canary deployment with the next version.

Go to your Git repository and change the file`gitops-certification-examples/blob/main/canary-app-timed/rollout.yaml` Change line 19 and enter v2.0 as the container image. Commit and push your changes.

Go into the ArgoCD UI and press the sync button to sync it.

Argo Rollouts will follow the pattern described in the rollout and do the following:

30% of traffic will be sent to the canary
After 2 minutes the canary will get 60% of traffic
After 2 more minutes 100% of the traffic will be sent to the canary
You can monitor the progress by using the command line
```sh
kubectl argo rollouts get rollout simple-rollout --watch
```

Notice that even though the next version of our application is already deployed, live traffic goes to both new/old versions. You can verify this by looking at the "live traffic" tab.

![version1](https://raw.githubusercontent.com/codefresh-contrib/gitops-certification-examples/main/pictures/canary.png)

Notice that at each step you can also look at the "stable" and "unstable" tabs and you can see that you can keep both old and new versions in play. This is useful if for some reason you have other applications in the cluster that always need to be pointed to the old or new version while a canary is in progress.

After all 4 minutes pass the canary is complete

Now all live traffic goes to the new version as can be seen from the "live traffic" tab.

![version1](https://raw.githubusercontent.com/codefresh-contrib/gitops-certification-examples/main/pictures/version2.png)

The deployment has finished successfully now.


