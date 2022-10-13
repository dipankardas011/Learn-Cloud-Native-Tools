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

# Postfix mail server not working
```sh
systemctl status postfix -l

vi /etc/postfix/main.cf
# here comment out inet_interface=localhost
```

# install squid and enable on restart

```sh
sudo yum install -y squid
sudo systemctl start squid
sudo systemctl enable squid

```


# Setup the jump server to ssh passwordless to all app server

```sh
ssh-keygen

ssh-copy-id tony@stapp01
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03
```

# to sync server time
used network time protocol

[GooglePublicNTP](https://developers.google.com/time/guides)
```sh
yum install -y ntp
vi /etc/ntp.conf
# add the server <Provided DNS>
```


# Configure the Apache http server

```sh
sudo yum install -y httpd

find / -type f -name httpd.conf

vi <>
Listen: 6000

# message to display
/var/www/html/index.html

# at the end
Header set X-XSS-Protection: "1; mode=block"
Header set X-Frame-Options: "SAMEORIGIN"
Header set X-Content-Type-Options: "nosniff"
```

# Increase the security of apache server
- remove the display of apache version
- disable the browsing of contents of a path in /var/www/blog
```sh
vi /etc/httpd/conf/httpd.conf

# add thses in bottom
ServerTokens Prod
ServerSignature Off

# to remove the browsing
# comment
Options Indexes FollowSymLinks
```

# Due to some malicious things we need to copy all the *php files under /var/www/html/ to /blog keeping the folder structire same without copiing all the contents of /var/www/html/blogs
```sh
find /var/www/html/blog -type f -name *.php
sudo find /var/www/html/blog -type f -name *.php -exec cp --parents {} /blog \;
```

# LogRotate

[LogRoate ManPage](https://linux.die.net/man/8/logrotate)

```sh
sudo apt install logrotate
sudo yum install logrotate

vi /etc/logrotate.d/*

# for httpd example
# to rotate monthly and 3 log at a time
cat /etc/logrotate.d/httpd
```
```diff
/var/log/httpd/*log {
	missingok
	notifempty
	sharedscripts
	delaycompress
- 
-
+	rotate 3
+	monthly
	postrotate
		/bin/systemctl reload httpd.service > /dev/null 2>/dev/null | true
	endscript
}

```

# Local YUM repo

```bash
# note the packages directory

cd /etc/yum.repos.d/
ls
# total 0

sudo vi <repo name>.repo
```

```conf
[repo-name]
Name=repo-name
baseurl=file:///<local-path>/
enabled=1
gpgcheck=0
```

```bash
sudo yum clean all

# then install package present in this
```

```conf
# vi /etc/yum.repos.d/customrepo.repo
[local] # its the id
name=My RPM System Package Repo
baseurl=file:///home/mypackage_dir/repository
enabled=1
gpgcheck=0
```


## over http server

```bash
yum install httpd
ln -s /var/www/html/repo /home/mypackage_dir/repo
service httpd start

vi /etc/yum.repos.d/

[node1-repo]
name=My RPM System Package Repo
baseurl=http:///repo
enabled=1
gpgcheck=0

yum repolist
```

# Application IPtables configs

```bash
sudo systemctl start iptables

ss -tnlp # to check the opeended/active socket and their port number (LISTENING)
ss -tnlp | grep nginx
ss -tnlp | grep httpd

sudo su
iptables -A INPUT -p tcp --dport <nginx-port> -j ACCEPT
iptables -A INPUT -p tcp --dport <httpd-port> -j REJECT

iptables -L
```

# Apache server redirect

# check the port on which it is listening
cat /etc/httpd/conf/httpd.conf | grep ^Listen

vi /etc/httpd/conf.d/main.conf
```conf
# permenant shift
<VirtualHost *:3000>
ServerName http://stapp02.stratos.xfusioncorp.com
Redirect 301 / http://www.stapp02.stratos.xfusioncorp.com:3000/
</VirtualHost>


# termorary shift
<VirtualHost *:3000>
ServerName http://www.stapp02.stratos.xfusioncorp.com:3000/blog/
Redirect 302 /blog/ http://www.stapp02.stratos.xfusioncorp.com:3000/news/
</VirtualHost>
```
