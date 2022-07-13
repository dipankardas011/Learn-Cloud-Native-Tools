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
