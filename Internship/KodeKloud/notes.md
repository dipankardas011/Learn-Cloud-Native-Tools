---
Author: Dipankar Das
Date: 2022-05-10
Topic: Tasks of KodeKloud
Draft: false
---
# user add

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

# how to disable direct root ssh login

```sh
sudo vi /etc/ssh/sshd_config

# here add PermitRootLogin no

sudo systemctl restart sshd
# --------------------------------
# how to set expireation time of a user
sudo usermod -e 2021-02-17 yousuf
# to verify
sudo chage -l yousuf

```

# to have folders to specific groups

```sh
sudo chgrp <target_group> -R <folder>

sudo chmod <> -R <folder>
```

# to set default GUI in centos

```sh
sudo systemctl set-default graphical.target
```

# to cp file not folders but keeping the folder structure same
```sh
find /home/usersdata -type f -user kareem -exec cp --parents {} /blog \;
```


# find and replace using sed

```sh
sudo sed '/code/d' BSD.txt > BSD_DELETE.txt # to delete the line containing code as word
sed 's/the/is/g' BSD.txt > BSD_REPLACE.txt # replace all the the worlds with is word
```


# copy the files
```sh
scp /tmp/nautilus.txt.gpg banner@stapp03:/home/webdata
```


# Resolve the issue with the dns resolution
```conf
$ cat /etc/resolv.conf

search stratos.xfusioncorp.com
nameserver 127.0.0.11
options ndots:0

# added GoogleDNS as nameserver

nameserver 8.8.8.8
nameserver 8.8.4.4

```

# have cronjobs
```sh
yum install -y cronie

systemctl start crond
systemctl status crond

crontab -l

crontab -e
# */5 * * * * echo hello > /tmp/cron_text this is a demo
```


# Installing SELinux for security but selinux policy should be disabled and can be trigered
```

yum install -y selinux*

steve@stapp02 ~]$ cat /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted


[steve@stapp02 ~]$ sudo vim /etc/selinux/config
sudo: vim: command not found
[steve@stapp02 ~]$ sudo vi /etc/selinux/config
[steve@stapp02 ~]$ sestatus
SELinux status:                 disabled
[steve@stapp02 ~]$
```

# how to add message of day

```sh
cat > /etc/motd
##################################
# welcome the amazing #
#################################
```

if the ssh not available
```sh
yum install openssh-clients
```


# Maria DB problem

```shell
sudo systemctl start mariadb
# some errors
sudo systemctl status mariadb
get the error msg that mysql is
# stdb01.stratos.xfusioncorp.com mariadb-prepare-db-dir[734]: Database MariaDB is not initialized, but the directory /var/lib/mysql is not empty, so initialization cannot be done

so mv /var/lib/mysqld /var/lib/mysql

```