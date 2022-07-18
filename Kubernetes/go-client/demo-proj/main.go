package main

import (
	"context"
	"fmt"

	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

func main() {
	// uses the current context in kubeconfig
	// path-to-kubeconfig -- for example, /root/.kube/config
	config, _ := clientcmd.BuildConfigFromFlags("", "/home/dipankar/.kube/config")
	// creates the clientset
	clientset, _ := kubernetes.NewForConfig(config)
	// access the API to list pods
	pods, _ := clientset.CoreV1().Pods("default").List(context.Background(), v1.ListOptions{})
	fmt.Printf("There are %d pods in the cluster\n", len(pods.Items))
	fmt.Println(pods.Items)

	fmt.Println(clientset.CoreV1().Pods("default").Get(context.TODO(), "", v1.GetOptions{}))

	dep, _ := clientset.CoreV1().Nodes().Get(context.TODO(), "", v1.GetOptions{})
	fmt.Println(dep)

	// fmt.Println(clientset.AppsV1().Deployments("").Get(context.TODO(), "", v1.GetOptions{}))
}
