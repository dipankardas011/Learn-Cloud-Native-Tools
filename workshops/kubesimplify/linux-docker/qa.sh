#! /bin/bash

redCol="\e[31m"
greenCol="\e[32m"
defCol="\e[0m"

> /tmp/result

function writeAnswer() {
    while true
    do
        read -r -p "Your answer: " answer
        case $answer in
            [1234]) echo "$answer" >> /tmp/result; break;;
            *) echo "Select proper answer!";;
        esac
    done
}

clear

echo -e "${greenCol}This is the final quiz!${defCol} Please follow the instructions and select proper answers. Good luck!"
echo "*****"

while true
do
  read -r -p "Are you ready? " answer
  case $answer in
    [Yy]*) echo "Good! Let's get started!"; break;;
    [Nn]*) echo "Then be ready! And start this quiz again."; exit;;
    *) echo "Yes, or no?";;
  esac
done

clear
echo "Question 1"
echo "-----------"
echo " I want to list my files with colored output. I should use:"
echo "-----------"
echo "1. ls --color=yes"
echo "2. ls --color"
echo "3. ls --clr"
echo "4. ls -c"

writeAnswer

clear
echo "Question 2"
echo "-----------"
echo " What is the difference between *ls -a* and *ls -A*?"
echo "-----------"
echo "1. output is printed in small or capital letters"
echo "2. no difference at all"
echo "3. -a will show all files with . and .., while -A will show all without . and .."
echo "4. -A will show all files with . and .., while -a will show all without . and .."

writeAnswer

clear
echo "Question 3"
echo "-----------"
echo " *mtime* is"
echo "-----------"
echo "1. any last modification of the file"
echo "2. last modification of the content"
echo "3. creation time"
echo "4. all answers are incorrect"

writeAnswer

clear
echo "Question 4"
echo "-----------"
echo " *man* is"
echo "-----------"
echo "1. command for manual execution of program"
echo "2. command to run manager (system's configuration and management tool)"
echo "3. command to show Linux Manifest"
echo "4. command to run manual - a help system"

writeAnswer

clear
echo "Question 5"
echo "-----------"
echo " *man 8 ls* will show"
echo "-----------"
echo "1. first 8 lines of manual page"
echo "2. 8 command examples"
echo "3. 8th page of manual"
echo "4. last 8 lines of manual"

writeAnswer

clear
echo "Question 6"
echo "-----------"
echo " Function of *pwd* command is"
echo "-----------"
echo "1. print working directory"
echo "2. print write directory permissions"
echo "3. change directory"
echo "4. change directory to user's default"

writeAnswer

clear
echo "Question 7"
echo "-----------"
echo " You are in data directory which is at top level in your home directory. You want to navigate to your home"
echo "-----------"
echo "1. cd \$HOME"
echo "2. cd .."
echo "3. cd"
echo "4. all answers are correct"

writeAnswer

clear
echo "Question 8"
echo "-----------"
echo " You have to remove directory data and everything what is inside"
echo "-----------"
echo "1. rmdir data"
echo "2. rmdir data -f"
echo "3. rm data"
echo "4. rm -rf data"

writeAnswer

clear
echo "Question 9"
echo "-----------"
echo " *touch* command will"
echo "-----------"
echo "1. create empty file"
echo "2. create directory"
echo "3. check if file can be created"
echo "4. create file with random content"

writeAnswer

clear
echo "Question 10"
echo "-----------"
echo " If I run *ls -al /etc/ | grep ssh | wc -l* I will receive"
echo "-----------"
echo "1. list of files with ssh in the file name"
echo "2. number of files with ssh in the file name"
echo "3. number of lines with ssh in the line"
echo "4. list of lines with ssh in the line and number, which is a sum of these lines"

writeAnswer

clear
echo "Question 11"
echo "-----------"
echo " *wc -l < file* will"
echo "-----------"
echo "1. write the number to the file"
echo "2. count number of characters in the file"
echo "3. print number of lines in the file"
echo "4. nothing. *<* is not valid in Linux, only Unix"

writeAnswer

clear
echo "Question 12"
echo "-----------"
echo " Which example represents the situation, when *Command2* operates on output from *Command1*?"
echo "-----------"
echo "1. Command2 | Command1"
echo "2. Command1 || Command2"
echo "3. Command1 | Command2"
echo "4. Command1 | Command3 | Command2"

writeAnswer

clear
echo "Question 13"
echo "-----------"
echo " *who* shows"
echo "-----------"
echo "1. id of the user who executes the command"
echo "2. currently logged users"
echo "3. users who are and were logged in specified period of time"
echo "4. who can execute specified command"

writeAnswer

clear
echo "Question 14"
echo "-----------"
echo " *ps* without any arguments shows"
echo "-----------"
echo "1. all processes in the system"
echo "2. all processes run by current user"
echo "3. all processes run by current shell"
echo "4. all system processes"

writeAnswer

clear
echo "Question 15"
echo "-----------"
echo " The output of *id* command shows"
echo "-----------"
echo "1. uid=0(root) groups=0(root) gid=0(root)"
echo "2. gid=0(root) groups=0(root) uid=0(root)"
echo "3. groups=0(root) uid=0(root) gid=0(root)"
echo "4. uid=0(root) gid=0(root) groups=0(root)"

writeAnswer

clear
echo "Question 16"
echo "-----------"
echo " *!* in /etc/shadow means"
echo "-----------"
echo "1. password must be changed"
echo "2. password is not set"
echo "3. password was never set"
echo "4. password is set but is weak"

writeAnswer

clear
echo "Question 17"
echo "-----------"
echo " I want to create *newuser* with bash as shell and create default home directory"
echo "-----------"
echo "1. useradd newuser"
echo "2. useradd newuser -s /bin/bash -m"
echo "3. useradd newuser -s -m"
echo "4. useradd newuser -s /bin/bash -h"

writeAnswer

clear
echo "Question 18"
echo "-----------"
echo " I want to add secondary group *docker* to user *newuser*"
echo "-----------"
echo "1. usermod -aG docker newuser"
echo "2. usermod -G docker newuser"
echo "3. usermod -g docker newuser"
echo "4. usermod -ag docker newuser"

writeAnswer

clear
echo "Question 19"
echo "-----------"
echo " *sudo command* allows"
echo "-----------"
echo "1. execute command"
echo "2. execute command as root"
echo "3. become root and execute command"
echo "4. fix potential typos in command"

writeAnswer

clear
echo "Question 20"
echo "-----------"
echo " *sudo command* allows"
echo "-----------"
echo "1. execute command"
echo "2. execute command as root"
echo "3. become root and execute command"
echo "4. fix potential typos in command"

writeAnswer

clear
echo "Question 21"
echo "-----------"
echo " *usermod -aG myuser sudo* will"
echo "-----------"
echo "1. add sudo command to user myuser"
echo "2. add myuser to sudoers file"
echo "3. change main group of user myuser to sudo"
echo "4. add sudo group as secondary to user myuser"

writeAnswer

clear
echo "Question 22"
echo "-----------"
echo " *myuser ALL=(ALL:ALL) ALL* in sudoers file means"
echo "-----------"
echo "1. myuser can execute any command as root, must confirm the action with his own password"
echo "2. myuser can execute any command as root, password is not needed"
echo "3. myuser can execute any command as root, must confirm the action with root password"
echo "4. every member of myuser group can execute any command as root, password is not needed"

writeAnswer

clear
echo "Question 23"
echo "-----------"
echo " By default all logs are stored in"
echo "-----------"
echo "1. /var/logs"
echo "2. var/log"
echo "3. /tmp/logs"
echo "4. /var/log"

writeAnswer

clear
echo "Question 24"
echo "-----------"
echo " STDERR id is"
echo "-----------"
echo "1. 0"
echo "2. 1"
echo "3. 2"
echo "4. 3"

writeAnswer

clear
echo "Question 25"
echo "-----------"
echo "I want to redirect all output and errors to *mylog*, I should use"
echo "-----------"
echo "1. mylog 2>&1 <action>"
echo "2. action >>> mylog"
echo "3. action 2>&1 mylog"
echo "4. action 2>1 mylog"

writeAnswer

clear
echo "Question 26"
echo "-----------"
echo "I want to add job to crontab. What command should I use?"
echo "-----------"
echo "1. cron -e"
echo "2. crontab -a"
echo "3. crontab -e"
echo "4. cron -a"

writeAnswer

clear
echo "Question 27"
echo "-----------"
echo "When logged as *myuser* I created a cronjob. Where my crontab file is located?"
echo "-----------"
echo "1. /var/spool/cron/crontabs/myuser"
echo "2. /var/cron/crontabs/myuser"
echo "3. /usr/cron/crontabs/myuser"
echo "4. /home/myuser/.crontab"

writeAnswer

clear
echo "Question 28"
echo "-----------"
echo "I want to check detailed information about *myfile*"
echo "-----------"
echo "1. file myfile"
echo "2. whatis myfile"
echo "3. check myfile"
echo "4. stat myfile"

writeAnswer

clear
echo "Question 29"
echo "-----------"
echo "I want to create soft link *mylink* to *myfile*"
echo "-----------"
echo "1. ln myfile mylink"
echo "2. ln -s myfile mylink"
echo "3. ln mylink myfile"
echo "4. ln -l myfile mylink"

writeAnswer

clear
echo "Question 30"
echo "-----------"
echo "I want to know if *myfile* has any hard links created"
echo "-----------"
echo "1. ln myfile"
echo "2. ln --show myfile"
echo "3. file myfile"
echo "4. stat myfile"

writeAnswer

clear
echo "Question 31"
echo "-----------"
echo "One of these statements is false. Select it"
echo "-----------"
echo "1. hard links can be created between different filesystems"
echo "2. hard links cannot be created for directories"
echo "3. when I remove the origin of soft link, the link itself will be broken"
echo "4. hard links share the same inode as original"

writeAnswer

clear
echo "Question 32"
echo "-----------"
echo "*drwxr-xr-x* means"
echo "-----------"
echo "1. device with all access for owner and read and execute for group and others"
echo "2. directory with all access for owner and read and execute for group and others"
echo "3. data file with all access for owner and read and execute for group and others"
echo "4. it is wrong syntax"

writeAnswer

clear
echo "Question 33"
echo "-----------"
echo "Translate *642*"
echo "-----------"
echo "1. rw-rw--w-"
echo "2. rwxr-x-wx"
echo "3. rw-r---w-"
echo "4. rw--wx-w-"

writeAnswer

clear
echo "Question 34"
echo "-----------"
echo "*chmod +x myfile* will"
echo "-----------"
echo "1. add execution permission to others"
echo "2. add execution permission to owner, group and others"
echo "3. add execution permission to owner"
echo "4. it is wrong syntax, it needs to have specific setting like o+x to set for owner, etc."

writeAnswer

clear

echo -e "${greenCol}Congratulations!${defCol}"
echo "Now you can check your score!"


# --------------------------

1
3
1
4
3
1
4
4
1
3
3
3
3
3
4
3
2
1
2
2
3
4
4
3
1
3
1
1
2
1
1
2
3
2
