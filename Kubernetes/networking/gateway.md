# Gateway in K8s

[Blog link](https://blog.flomesh.io/kubernetes-gateway-api-evolution-of-service-networking-aa76ec4efa7e)

Gateway API has taken the lessons from ingress and also the service mesh community on up-leveling the Kubernetes-natives resources that we use to model service networking. The Gateway API adds support for:

• HTTP header-based matching

• HTTP header manipulation

• Weighted traffic splitting

• Traffic mirroring

• Role-oriented resource model

• and more

Gateways are created from GatewayClass and they model the actual network infrastructure which processes the traffic, like your actual load balancer. A Gateway describes how traffic can be translated to Services within the cluster. That is, it defines a request for a way to translate traffic from somewhere that does not know about Kubernetes to somewhere that does. For example, traffic is sent to a Kubernetes Service by a cloud load balancer, an in-cluster proxy, or an external hardware load balancer. Gateways are designed to be abstract so that they can model many different kinds of data planes that perform routing.

And then you have Route Resources, which define protocol-specific rules for mapping requests from a Gateway to Kubernetes Services.
