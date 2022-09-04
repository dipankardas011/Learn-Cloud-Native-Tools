—--
Topic: Introduction to CRI
—--

# Prerequisites
- Docker
- Kubernetes

# What is CRI?
The CRI is a plugin interface which enables the kubelet to use a wide variety of container runtimes, without having a need to recompile the cluster components.

## What is the Open container initiative (OCI)?
The Open Container Initiative is an open governance structure for the express purpose of creating open industry standards around container formats and runtimes.

## Containerd
It is a CNCF Graduated project which is OCI Standard. Its is a container manager tool. All other container management tools make use of containerd to run containers Like Kubernetes, Docker, Nerdctl
![Image](https://raw.githubusercontent.com/containerd/containerd/main/docs/historical/design/architecture.png)

Why to learn -> However, since it's the closest thing to the actual containerd API, it can serve as a great exploration means - by examining the available commands, you can get a rough idea of what containerd can and cannot do. You can also replace the other tools with containerd + nerdctl in your local environment.

## Nerdctl, Crictl, ctr
These are CLI tools for running and managing the containers being run by containerd
Among these ctr is pre shipped when containerd is installed and you’ve to install crictl and nerdctl manually.

# Local Setup

One of the best hassle-free way to install containerd along with nerdctl is to use arkade. If you’re hearing about arkade for the first time, then checkout the blog here

```sh
arkade system install containerd
arkade get nerdctl
arkade system install cni -p /usr/libexec/cni
```

The containerd.io packages in DEB and RPM formats are distributed by Docker (not by the containerd project). See the Docker documentation for how to set up apt-get or dnf to install containerd.io packages:

CentOS, Debian, Fedora, Ubuntu
The containerd.io package contains runc too, but does not contain CNI plugins.
```sh
sudo yum install -y containerd.io
Sudo apt install -y containerd.io
```

We need CNI (Container networking interface)
Installing CNI plugins
Download the cni-plugins-<OS>-<ARCH>-<VERSION>.tgz archive from [Tar File to download](https://github.com/containernetworking/plugins/releases) , verify its sha256sum, and extract it under /opt/cni/bin

```sh
$ mkdir -p /opt/cni/bin
$ tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-<Version>.tgz
```

# What are the options and why in `ctr`

```shell
ctr run <image-ref> <container-id>
```

# Translate docker learnings to `nerdctl`
```sh
$ brew install nerdctl

# do this when you need access to nerdctl in root user (Root install)
$ sudo cp -v /home/linuxbrew/.linuxbrew/bin/nerdctl /usr/local/bin/
$ sudo nerdctl version
```

# So all setup is done let's go through some concepts

What is namespace, snapshot, tasks in containerd terms

A Task is the runtime state of the container.
<!-- filling  -->

> NOTE:  Instead of building images with ctr, you can import existing images built with docker build or other OCI-compatible software.

Start and stop container
```sh
# When pulling images, the fully-qualified reference seems to be required, so you cannot omit the registry or the tag part
$ ctr images pull docker.io/library/hello-world:latest
$ ctr run docker.io/library/hello-world:latest hello

Hello from Docker!
…..

$ ctr -namespace default container ls

$ ctr container rm hello
```

Surprisingly, containerd doesn't provide out-of-the-box image building support. However, containerd itself is often used to build images by higher-level tools.
When you do ctr create container then task are not automatically created


When using ctr run taks is creaated



Create Namespace
```sh
$ ctr ns create <name>

$ctr ns rm <name>
```

> ctr run command is actually a shortcut for ctr container create + ctr task start

Lets exec into a container which is running in detach mode


Now to stop the container


Got error
```sh
# first stop the task
ctr task kill nginx
ctr task ls
# will see that  the taks is now stopper state

ctr c rm nginx
```

Now you understand that its not very practical to use ctr in day to day use only for debugging so there is another alternative to docker cli which is nerdctl which is _almost_ compatible with most of the docker commands and is easy to use

[Playground Link](https://killercoda.com/kranurag7/course/playgrounds/nerdctl)

[Some more resource](https://iximiuz.com/en/posts/containerd-command-line-clients/)


# Authors
- Anurag
- Dipankar
<!-- Some features docker doesn’t have but will be available -->


