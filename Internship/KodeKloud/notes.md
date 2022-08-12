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
# --------------------------------
# how to set expireation time of a user
sudo usermod -e 2021-02-17 yousuf
# to verify
sudo chage -l yousuf

```

to have folders to specific groups

```sh
sudo chgrp <target_group> -R <folder>

sudo chmod <> -R <folder>
```

to set default GUI in centos

```sh
sudo systemctl set-default graphical.target
```

to cp file not folders but keeping the folder structure same
```sh
find /home/usersdata -type f -user kareem -exec cp --parents {} /blog \;
```


find and replace using sed

```sh
sudo sed '/code/d' BSD.txt > BSD_DELETE.txt # to delete the line containing code as word
sed 's/the/is/g' BSD.txt > BSD_REPLACE.txt # replace all the the worlds with is word
```


copy the files
```sh
scp /tmp/nautilus.txt.gpg banner@stapp03:/home/webdata
```
