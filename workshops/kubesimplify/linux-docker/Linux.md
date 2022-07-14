# Linux
CTRL+R to get previous commands
[Github link](https://github.com/chadmcrowell/linux-docker)

# Docker

if we make a dir in the cgroups then the contents are copies of that dir
if makeing inside the memory cgroup then it is like cloning the memory cgroup

to limit or set the memory limit use `memory.limit_in_bytes`
to limit specific process enter the PID to the `cgroup.procs`

```sh
apt install -y cgroup-tools
```

the whoami is not child of unshare but it is of sudo
so once the 1 process exec then no longer allowed

**refer to Screenshot**

```sh
sudo unshare --pid --fork sh
```


## Chrooted environment for filesystem (behind the scenes)

chroot - changing root
if i change any directory in the file system
you cannot view higher than that

```sh
cd /usr/bin
# after this
chroot

# its used to change the root directory to the $pwd
# then you neither view contents in /usr/ nor /
```

> So we can save alpine tar and extract to some location and then chroot to that path then it is basically create kind of a CONTAINER!!

![Linux-Docker-Github](https://github.com/chadmcrowell/linux-docker)