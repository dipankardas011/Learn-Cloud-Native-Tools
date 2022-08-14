
```sh
# install the java in ec2 instance
sudo yum install java-11-amazon-corretto
```

```sh
# find the path of the java
ls -l | grep /usr/bin/java
ls -l | grep /etc/alternatives/java # here you will get the -->> extact path
ls -l /usr/lib/jvm/java-11-amazon-corretto.x86_64/bin
```

```sh
sudo su - 

cd /opt/

wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.23/bin/apache-tomcat-10.0.23.tar.gz

sudo tar -xvzf apache-tomcat-10.0.23.tar.gz

cd apache-tomcat-10.0.23/bin
chmod +x startup.sh
chmod +x shutdown.sh

ln -s /opt/apache-tomcat-10.0.23/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/apache-tomcat-10.0.23/bin/shutdown.sh /usr/local/bin/tomcatdown

tomcatup
tomcatdown

cd /opt/apache-tomcat-10.0.23/conf
vim server.xml # change the port from 8080 -> 8090


# Configurations
find / -name context.xml
vim /opt/apache-tomcat-10.0.23/webapps/host-manager/META-INF/context.xml
#
#Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
# comment out these lines in both the files
#
vim /opt/apache-tomcat-10.0.23/webapps/manager/META-INF/context.xml
```

```sh
# add users
cd /opt/apache-tomcat-10.0.23/conf
vim tomcat-users.xml
```

add this to `tomcat-users.xml`
```xml
<role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
  <user username="deployer" password="deployer" roles="manager-script"/>
  <user username="tomcat" password="s3cret" roles="manager-gui"/>
```


