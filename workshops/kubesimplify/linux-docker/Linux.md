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




# What is crontab
Although the title is about crontab, we start our story from something else - cron.

Cron, the daemon
What is service, or daemon, how to use them - we will learn later. Now it is enough to say, that cron is a service responsible for control and execution of scheduled tasks. It is started when system is booting and works till the system is shut down.

Let's see a few ways how we can check the status of the service.

```sh
systemctl status cron.service

```
This command is a management command for systemd. What is interesting for us at this moment is only this part of the displayed information:

Active: active (running)

This means that the service is active.

```sh
ps aux | grep cron

```
Shows processes related to the cron service. We should see something similar to

root 565 0.0 0.1 8536 3084 ? Ss 19:48 0:00 /usr/sbin/cron -f

So, to conclude this part, cron is a service which controls multiple crontabs.

Crontab
We know what is cron already. So, what is crontab?

crontab is simply a list of tasks or commands which are scheduled to be executed on specific date and time. The thing is, that Linux have many crontabs. Let's go through them.

```sh
/etc/crontab
```
The first file we discuss is located in /etc/ directory. Let's see it

```sh
ls -al /etc/crontab
```

This is the system wide crontab. As you can see, all users can read, but only admins can edit this file. What we keep there? Generally, system related, admin stuff. But please remember, it is not root's crontab, this one is somewhere else. Again, it is system-wide crontab.

This crontab has associated directory - /etc/cron.d. Let's see what is inside

```sh
ls -al /etc/cron.d
```

Well, here we have scrips, which are scheduled in /etc/crontab.

cron.daily and others
In this directory we have a few more directories.

```sh
ls -al /etc/cron.* -d
```

You should see

drwxr-xr-x 2 root root 4096 Oct  7  2021 /etc/cron.daily
drwxr-xr-x 2 root root 4096 Oct  7  2021 /etc/cron.hourly
drwxr-xr-x 2 root root 4096 Oct  7  2021 /etc/cron.monthly
drwxr-xr-x 2 root root 4096 Oct  7  2021 /etc/cron.weekly
I think you get the idea. These directories contain scripts which are executed... daily, hourly, monthly or weekly.

Let's see one example

```sh
ls -al /etc/cron.daily
```

Well, there is no crontab, only scripts (and .placeholder, which is obligatory). If you don't believe me, check :)

```sh
cat /etc/cron.daily/dpkg
```

How these are executed? How system knows when to do it? Well, the answer is in the file which we already know:

```sh
cat /etc/crontab
```

We have four anacron command executed with different scheduling. We will learn about it later. What is anacron?

It is scheduler too. But works a little bit differently than cron. Unlike the cron, anacron doesn't assume that the machine is run continuously without stops. It is crucial for system's scripts which must be executed daily, for example.

Ok, let's jump to another location.
```sh
/var/spool/cron/crontabs
```

In this directory (which is empty at this moment) user's crontabs are stored. It is related to root's crontab as well.

ls -al /var/spool/cron/crontabs we confirmed, the directory is empty. It is time to jump to the next chapter and learn how to define task in crontab!



# Setting cronjob
Each entry in crontab is called cronjob.

To list our jobs, we execute

```sh
crontab -l
```

What we see now, is

no crontab for root. It is because there is no job defined.

Let's define a job, which will be executed at 9:12, every 23rd day of month. We want to do ls of /var/log send all output to logfile.

> crontab -e opens crontab editor. (at the first time, we need to set the default editor. I prefer vim :) )

Let's put there

```sh
12 9 23 * * /usr/bin/ls -al > logfile 2>&1
```

And save the file with :wq

You should see installing new crontab

Is it set?

```sh
crontab -l
```

Yes, it is!

As you can see, I intentionally used usr/bin/ls - full, absolute path. It is not needed in this example, however it is a good practice to do. Remember, cronjob, when executed, will create another shell. We need to ensure that this newly created shell is able to use our system. In this example, when I use ls, my shell is looking for executable in defined $PATH. What will happen, if new shell will not have $PATH defined?
Ok, let's change something to see, if it really works. Change the schedule to * * * * * - every minute.

Now we need to wait a moment, and the nwe should be able to successfuly execute

```sh
cat logfile
```

Yeah! We have our first crontab!

Where is it configured? Do you remember material from previous page?

```sh
ls -al /var/spool/cron/crontabs/root
```

Yes, we have a file, root. It means, user root created it, root is an owner, and the group assigned is crontab. Let's look inside

```sh
cat /var/spool/cron/crontabs/root
```

The file contains exactly what we defined.

# Logs
Different Linux distribution will log cronjob execution in different logs. Here, in Ubuntu, we need to go through /var/log/syslog. Execute

```sh
cat /var/log/syslog
```

and look for May 13 22:31:01 ubuntu CRON[24797]: (root) CMD (/usr/bin/ls -al > logfile 2>&1) (date for you will be different, obviously)

We can use journactl as well

```sh
journalctl -u cron
```

We run journalctl for all entries for user cron

Obviously, we can use also the systemctl command

```sh
systemctl status cron.service
```



Going advanced
We are about to finish the fundamental training. So, let's make things more complicated.

```sh
blockdev --getbsz /dev/vda
```

This way we determined the block size used on the filesystem. Do you remember another way of doing it from previous lesson?

We received 4096. Ok, we use it in

```sh
df -B 4096 /dev/vda1
```

We asked about disk usage, but this time, we said that we are interested in -B block size equal to 4096. Yes, the percentage is the same, but we can determine how many files we can write.

Let's do a small excercise.

```sh
df /dev/vda1
df -B 4096 /dev/vda1
echo 'this is my new file with some content' > testfile
df /dev/vda1
df -B 4096 /dev/vda1

```
Please, compare the results.

More about files
We know how to get info about inode of the file. We can get interesting information about our testfile, using crazy looking command

```sh
debugfs -R "stat <$(ls -il testfile | awk '{print $1}')>" /dev/vda1
```

(quit with q - it is simple less)

And compare it with

```sh
debugfs -R "stat <$(ls -il /var/log/syslog | awk '{print $1}')>" /dev/vda1
```

We immediately see the difference on the end, in EXTENDS. This crazy command extracted thee information about inodes used by this file. This metadata describees in two numbers the first and last block of the file. In the example with syslog we clearly see the fragmentation.

More about directories
Run

```sh
pwd

```
We determined, that we are in /root dirctory.

```sh
ls -ild /root

```
Note the inode. now execute the same but for parent directory

```sh
ls -ild /
```

Note the inode as well. And finally run
```sh
ls -ial /root
```
Please, compare the inodes for . and ... In our case the inode for / is equal to .. and inode for /root is equal to .. What makes sense, as . here means /root in absolute path. We talk here about our current directory. Adequately for / and .. - it is the parent directory.

