---
author: Dipankar Das
topic: devops
subtopic: begineer
---

# Kubernetes Time Check Pod

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: time-config
  namespace: nautilus
data:
  TIME_FREQ: "9"
---
apiVersion: v1
kind: Pod
metadata:
  name: time-check
  namespace: nautilus
spec:
  volumes:
  - name: log-volume
    emptyDir: {}
  containers:
  - name: time-check
    image: busybox:latest
    volumeMounts:
    - name: log-volume
      mountPath: "/opt/sysops/time"
    command: ["/bin/sh"] 
    args: ["-c", "while true; do date >> /opt/sysops/time/time-check.log; sleep $TIME_FREQ; done"]
    env:
    - name: TIME_FREQ
      valueFrom:
        configMapKeyRef:
          name: time-config
          key: TIME_FREQ
```

# Deploy Jenkins on Kubernetes

```yml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
  namespace: jenkins
  labels:
    app: jenkins
spec:
  selector:
    matchLabels:
      app: jenkins
  replicas: 1
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
      - name: jenkins-container
        image: jenkins/jenkins
        ports:
          - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - targetPort: 8080
      nodePort: 30008
      port: 8080
...
```

# Ansible Setup Httpd and PHP

```yml
---
- name: Setup Httpd and PHP
  hosts: stapp03
  become: yes
  tasks:
    - name: Install latest version of httpd and php
      ansible.builtin.package:
        name:
          - httpd
          - php
        state: latest

    - name: Replace default DocumentRoot in httpd.conf
      ansible.builtin.replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: 'DocumentRoot "\/var\/www\/html\"'
        replace: 'DocumentRoot "/var/www/html/myroot"'

    - name: Create the new DocumentRoot directory if it does not exist
      ansible.builtin.file:
        path: /var/www/html/myroot
        state: directory
        owner: apache
        group: apache

    - name: Use Jinja2 template to generate phpinfo.php
      ansible.builtin.template:
        src: /home/thor/playbooks/templates/phpinfo.php.j2
        dest: /var/www/html/myroot/phpinfo.php
        owner: apache
        group: apache

    - name: Start and enable service httpd
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes 
...
```

# Config ACL using ansible

```yaml
- name: Config for stapp01
  hosts: stapp01
  become: yes
  tasks:
    - name: Create the file
      ansible.builtin.file:
        path: /opt/sysops/blog.txt
        state: touch
        owner: root

    - name: ACL permissions
      ansible.posix.acl:
        path: /opt/sysops/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present

- name: Config for stapp02
  hosts: stapp02
  become: yes
  tasks:
    - name: Create the file
      ansible.builtin.file:
        path: /opt/sysops/story.txt
        state: touch
        owner: root

    - name: ACL permissions
      ansible.posix.acl:
        path: /opt/sysops/story.txt
        entity: steve 
        etype: user
        permissions: rw
        state: present

- name: Config for stapp03
  hosts: stapp03
  become: yes
  tasks:
    - name: Create the file
      ansible.builtin.file:
        path: /opt/sysops/media.txt
        state: touch
        owner: root

    - name: ACL permissions
      ansible.posix.acl:
        path: /opt/sysops/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present

```

# Ansible Create Users and Groups

```yaml
- name: Config for stapp02
  hosts: stapp02
  become: yes
  tasks:
  - name: Create the developers group
    ansible.builtin.group:
      name: developers
      state: present

  - name: Create the admins group
    ansible.builtin.group:
      name: admins
      state: present

  - name: Add admin users
    ansible.builtin.user:
      name: "{{ item }}"
      groups: admins,wheel
      state: present
      password: "{{ 'B4zNgHA7Ya' | password_hash ('sha512') }}"
    loop:
      - rob
      - joy
      - david


# -------------

  - name: Add dev users
    ansible.builtin.user:
      name: "{{ item }}"
      group: developers
      home: "/var/www/{{ item }}"
      state: present
      password: "{{ 'LQfKeWWxWD' | password_hash ('sha512') }}"
    loop:
      - ray
      - jim
      - mark
      - tim

```

cat ansible.cfg 
```conf
[defaults]
host_key_checking = False
vault_password_file=~/playbooks/secrets/vault.txt
```


# Deploy Nginx and Phpfpm on Kubernetes

```yaml

---
apiVersion: v1
kind: Service
metadata:
  name: php-fms-service
spec:
  type: NodePort
  selector:
    app: abcd
  ports:
  - port: 8091
    targetPort: 8091
    nodePort: 30012
---

apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |

    events {
    
    }

    http {
      log_format main
              'remote_addr:$remote_addr\t'
              'time_local:$time_local\t'
              'method:$request_method\t'
              'uri:$request_uri\t'
              'host:$host\t'
              'status:$status\t'
              'bytes_sent:$body_bytes_sent\t'
              'referer:$http_referer\t'
              'useragent:$http_user_agent\t'
              'forwardedfor:$http_x_forwarded_for\t'
              'request_time:$request_time';
      access_log        /var/log/nginx/access.log main;
      server {

          listen 8091;
          server_name localhost;

          root /var/www/html;
          index index.html index.htm index.php;

          location / {
          try_files $uri $uri/ =404;
          }

          location ~ \.php$ {
          include fastcgi_params;
          fastcgi_param REQUEST_METHOD $request_method;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_pass 127.0.0.1:9000;

          }
      }
    }
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-phpfpm
  labels:
    app: abcd
spec:

  volumes:
  - name: shared-files
    emptyDir: {}
  - name: nginx-config-volume 
    configMap:
      name: nginx-config

  containers:
  - name: nginx-container
    image: nginx:latest
    volumeMounts:
    - name: shared-files
      mountPath: /var/www/html
    - name: nginx-config-volume
      mountPath: /etc/nginx/nginx.conf
      subPath: nginx.conf
    ports:
    - containerPort: 8091

# Our php-fpm application 
  - name: php-fpm-container
    image: php:7.3-fpm
    volumeMounts:
    - name: shared-files
      mountPath: /var/www/html
    ports:
    - containerPort: 8091
```

```bash
kubectl cp /opt/index.php nginx-phpfpm:/var/www/html -c nginx-container
kubectl exec -it nginx-phpfpm nginx-container -- ls -la /var/www/html
```

# Ansible Config File Update

need to change the default remote user from root -> XyZ

```bash
cd /etc/ansible/

vi /etc/ansible/ansible.cfg

# find and replace remote_user = XyZ

```

# Puppet setup database

> Create a puppet programming file ecommerce.pp under /etc/puppetlabs/code/environments/production/manifests directory on puppet master node i.e on Jump Server. Define a class mysql_database in puppet programming code and perform below mentioned tasks:
Install package mariadb-server (whichever version is available by default in yum repo) on puppet agent node i.e on DB Server also start its service.
Create a database kodekloud_db2 , a database userkodekloud_roy and set passwordB4zNgHA7Ya for this new user also remember host should be localhost. Finally grant full permissions to this newly created user on newly created database.


```bash
# jump server
sudo su
cd /etc/puppetlabs/code/environments/production/manifests/

vi ecommerce.pp

cat ecommerce.pp << EOF
class mysql_database {
    package {'mariadb-server':
      ensure => installed
    }

    service {'mariadb':
        ensure    => running,
        enable    => true,
    }    

    mysql::db { 'kodekloud_db2':
      user     => 'kodekloud_roy',
      password => 'B4zNgHA7Ya',
      host     => 'localhost',
      grant    => ['ALL'],
    }
}

node 'stdb01.stratos.xfusioncorp.com' {
  include mysql_database
}
EOF

puppet parser validate ecommerce.pp

# as the server db 1
ssh peter@stdb01
puppet agent -tv
```
