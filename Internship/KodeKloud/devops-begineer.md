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
