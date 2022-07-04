[](https://faun.pub/how-to-setup-scalable-jenkins-on-kubernetes-f5c1b7d439cd)

```sh
kubectl create ns jenkins
kubectl -n jenkins apply -f jenkins

kubectl get svc -njenkins -owide

# externalIP:8080

```

After installing `kubernetes-plugin` for Jenkins
* Go to Manage Jenkins | Bottom of Page | Cloud | Kubernetes (Add kubenretes cloud)
* Fill out plugin values
    * Name: kubernetes
    * Kubernetes URL: https://kubernetes.default.svc
    * Kubernetes Namespace: jenkins
    * Credentials | Add | Jenkins (Choose Kubernetes service account option & Global + Save)
    * Test Connection | Should be successful! If not, check RBAC permissions and fix it!
    * Jenkins URL: http://lb-url
    * Tunnel : lb-url:50000
    * Apply cap only on alive pods : yes!
    * Add Kubernetes Pod Template
        * Name: jenkins-slave
        * Namespace: jenkins
        * Service Account: jenkins
        * Labels: jenkins-slave (you will need to use this label on all jobs)
        * Containers | Add Template
            * Name: jnlp
            <!-- * Docker Image: aimvector/jenkins-slave -->
            * Docker Image: dipugodocker/jenkins-slave
            * Command to run : <Make this blank>
            * Arguments to pass to the command: <Make this blank>
            * Allocate pseudo-TTY: yes
            * Add Volume
                * HostPath type
                * HostPath: /var/run/docker.sock
                * Mount Path: /var/run/docker.sock
        * Timeout in seconds for Jenkins connection: 300