user add

```sh
useradd -m <> -s /sbin/nologin # for non interactive shell

usermod -aG sudo <> # add <> user to sudo group

chmod +rx <> # for shell script that can be executed from anywhere


# for changing the time zone of a system
sudo ln -sf /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
date +%Z
timedatectl


# user without home
useradd -M <>
```

how to disable direct root ssh login

```sh
sudo vi /etc/ssh/sshd_config

# here add PermitRootLogin no

sudo systemctl restart sshd
```
