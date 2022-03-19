# Pod lifecycle


kubectl apply -f <> [kubectl]()  ➡️(((YAML->JSON)))➡️   [api server]()

[api server]() authenticate uing kubeconfig auth and checks whether the user is authorized or not to a particular functionality (i.e. creation, deletion) ➡️➡️ After all that the data gets persisted to the [etcd]() 😇 here `state` becomes [Pending]()

Now the [Scheduler]() comes and it finds a best match of node where it has to be spanned (i.e. iterate through all the nodes in the cluster to get the best possible based on the resources or images pulled or not ) 
after getting it sends the labels filled the `spec <node name>` & send it to the [api server]() now that particular request is also stored on the [etcd]() 😇 here `state` becomes [Container Creating]()

[api server]() Instructs the [kubelet]() of that particlar node  [kubelet]() is responsible to fetch the image from [image registry]() the [cri]() gets the ip attached to the pod which is send to the [api server]()
and again data is stored  in [etcd]() 😇 here `state` becomes [Running]()

Whenever the process dies too many times then 😇 here `state` becomes [Crash loop back off]()

and whenever the process succeded then 😇 here `state` becomes [succeeded]()

the pod is constantly checks for these:
---
## liveliness probe
/health

## Readiness probe
/ready
---
if it fails then 😇 here `state` becomes [Crash loop back off]()


## Hooks

actions that you want to before the conatiner starts

### just before it stops
pre-stops hooks

### just after it starts
post-start hook

### init container
it runs before running the main container

---

# Init containers
are the container that run to completion and runs before the main containner starts
## use case
to change the file structure or something like that
used to limit the attak surface
it can be used to delay the start up of the main container so that certain checks are done before hand

first all the init container are done then only the main container will start
there is 🚫 liveliness, readiness
