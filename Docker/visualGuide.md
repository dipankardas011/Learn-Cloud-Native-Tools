All steps in a dockerfile don't create a layer
only
1. RUN
2. ADD
3. COPY
other are intermediate layers
the intermediate layers are removed during the `docker build` and do not influence


> WARNING! `FROM` instruction does not use the cache!

want the list of all layers fofr a given image
```sh
docker history my-image --no-trunc
```

i want to display layers digest for a given image

```sh
docker inspect -f '{{json.RootFS.Layers}}' ubuntu | jq .
```

to build a dockerfile in different path

```sh
docker build -f build/Dockerfile -t name-image:tag .
```

docker build knows there is no changes to avoid this
```sh
docker build -t my-image --no-cache .
```


to build images of dockerfile in github

```sh
docker build -t image:tag <git-url>#branch:folder
```

Dangling images are untagged images and not used by containers

also known as "none:none" images

it is created when new image is build with same same and tag as old one

> CAREFUL! even if they are not used they take up disk space

```sh
# for dangling images
docker images --filter dangling=true
#to remove then we use
docker image prune
```
by default docker daemon pushes 5 layers of an image at a time

if want to make own registry
```json
{
	"debug": true,
	"insecure-registry":[
		"my-registry.com:8080"
	],
	"max-concurrent-uploads": 3
}
```

to pull all taggs of the image
```sh
docker pull --all-tags ubuntu
```


images
registry-url/user/image-name:tag

to tag my image
```sh
docker tag img-nam:tag registry/img-nam:tag
```
postgressdb

```sh
docker run -it --rm -p 5432 \
-e POSTGRES_USER=my-user \
-e POSTGRES_PASSWORD=my-password \
postgres:9.6.10-alpine
```

want to write the containerID in a file
```sh
docker run --cidfile /tmp/cid.txt ubuntu echo "Hi!"
```


```sh
# to restart after 15 sec
docker restart -t 15 <my-container>
```
# Volumes

volumes do not increae the size of a container

volume lifecycle != container lifecycle

volumes are stored in host file system
/var/lib/docker/volumes/

want to attach a running container's volume to another container


```sh
docker run -it --volumes-from my-vol my-container2 /bin/bash
```


ro -> readonly
rw -> read-write

```sh
docker run \
-d \
-v nginx-vol:/usr/share/nginx/html:ro \
--name nginx-vol nginx:latest
```

to delete all volumes
docker volumes prune


# Events
by default last 1000 logs events are displayed

```sh
docker events --since '5m'
```

```sh
docker events --filter 'container=${docker ps -lq}'

# -l =last -q = quiet

docker events --format '{{json .}}' --since '5m' | jq


# display image events
docker events --filter 'image=busybox'

# events of stop of container
docker events --filter 'container=my-container' --filter 'event=stop'
```

# Search

docker search <image name>

private registry
```sh
docker earch <registry_host>:<registry_port>/my-image
```

```sh
# with more than 10 stars 
docker search --filter=stars=10 debian


# official with 5 results
docker search -f=is-official=true --limit 5 alpine

# custom format
docker search --format "{{.Name}}\t{{.StarCount}}\t{{.IsOfficial}}" nginx

```


# DockerIgnore

its same as .gitignore
makes it possible not to include sentive data in a docker image such as keys, token, credentials, the conf of your favourite IDE our CI/CD logs or even test reports


# Env

```Dockerfile
FROM alpine
ARG PORT_ARG=3000

ENV PORT=$PORT_ARG
```

```sh
docker run --env-file=myfile.env my-image:tag
```


> NOTE! if you pass an environment value through -e & --env-file the final value will be the one provided by **-e option**

# Pass Build args

ARG instruction
defines a variable that can be passed at build time

this overrides build arguments the `ARG` instruction have scope the `ARG` must be defined before the `FROM` instruction in order to have an effect on the latter. otherwise we can define the arg instruction after the FROM build variables are arg instructions are visible through docker history dont use for sensite information

```Dockerfile
ARG img_name=golang
ARG img_version=latest
FROM $img_name:$img_version as build
```

or use cmd
```sh
$ docker build -t my-image:tag \
--build-arg img_name=bitnami/golang \
--build-arg img_version=1.17.7
```

want to pass value
```Dockerfile
FROM busybox
ARG user
RUN echo "user is $user"
```

```sh
docker build -t my-image:tag --build-arg user=moby .
```

# Security

by default container are not privileged and therefre not allowed access devices on the host
--privileged option grants a container root capabilities to all devices on the host
using this mode you can run a docker daemon inside a container please note that it is not recommedded to run previleged container in a production environment so be careful --devices option grants extended previleges to a container and reduce the risk of previled mode

by default containers can read, write, and mknod devices but you can customize these rights
--cap-add and --cap-drop options add ans remove Linux features

```sh
docker run --privileged my-image:tag
```

```sh
# it mount a temporary filesystem
docker run -it --privileged ubuntu mount -t tmpfs none /mnt
```

to check whether a container has privileged mode enabled or not

```sh
docker inspect --format '{{HostConfig.Privileged}}' my-container


# only read a partion table
docker run --device /dev/sda:/dev/xvdc:r --rm -it ubuntu

# for read write a partition table
docker run --device /dev/sda:/dev/xvdc:rw --rm -it ubuntu


# for mknod permission write m instead
docker run --device /dev/sda:/dev/xvdc:m --rm -it ubuntu
```

to run a container with all capabilities except for chown one

```sh
docker run --cap-add ALL --cap-drop CHOWN ubuntu

# want to run a container which mount a FUSE based fs
docker run --rm -it --cap-add SYS_ADMIN -device /dev/fuse sshf
```


THANK YOU!!!
