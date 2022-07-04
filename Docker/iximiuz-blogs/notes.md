# Create Network Namespace

```sh
#!/usr/bin/env bash

echo "> Network devices"
ip link

echo -e "\n> Route table"
ip route

echo -e "\n> Iptables rules"
iptables --list-rules
```
```sh
# run
sudo iptables -N ROOT_NS
chmod +x ./inspect.sh
sudo ./inspect.sh
```

## Host
```sh
sudo ip netns add netns0
ip netns
```


## Virtual
```sh
sudo nsenter --net=/var/run/netns/netns0 bash
# The newly created bash process lives in netns0
\# sudo ./inspect-net-stack.sh
```
![](https://iximiuz.com/container-networking-is-simple/network-namespace-4000-opt.png)

# Connecting containers to host with virtual Ethernet devices (veth)

## Host

```sh
sudo ip link add veth0 type veth peer name ceth0
ip link
sudo ip link set ceth0 netns netns0

sudo ip link set veth0 up
sudo ip addr add 172.18.0.11/16 dev veth0
```

## And continue with the netns0:
```sh
sudo nsenter --net=/var/run/netns/netns0
ip link set lo up  # whoops
ip link set ceth0 up
ip addr add 172.18.0.10/16 dev ceth0
ip link
```

![](https://iximiuz.com/container-networking-is-simple/veth-4000-opt.png)

Testing
```sh
# From `netns0`, ping root's veth0
ping -c 2 172.18.0.11

# From root namespace, ping ceth0
ping -c 2 172.18.0.10
```



# Some more namespaces

```sh
# From root namespace
sudo ip netns add netns1
sudo ip link add veth1 type veth peer name ceth1
sudo ip link set ceth1 netns netns1
sudo ip link set veth1 up
sudo ip addr add 172.18.0.21/16 dev veth1
sudo nsenter --net=/var/run/netns/netns1

ip link set lo up
ip link set ceth1 up
ip addr add 172.18.0.20/16 dev ceth1
```

# Cleanup
```sh
sudo ip netns delete netns0
sudo ip netns delete netns1

# But if you still have some leftovers...
sudo ip link delete veth0
sudo ip link delete ceth0
sudo ip link delete veth1
sudo ip link delete ceth1
```


# create Bridge network

```sh
sudo ip netns add netns0
sudo ip link add veth0 type veth peer name ceth0
sudo ip link set veth0 up
sudo ip link set ceth0 netns netns0

sudo nsenter --net=/var/run/netns/netns0
ip link set lo up
ip link set ceth0 up
ip addr add 172.18.0.10/16 dev ceth0
exit

sudo ip netns add netns1
sudo ip link add veth1 type veth peer name ceth1
sudo ip link set veth1 up
sudo ip link set ceth1 netns netns1

sudo nsenter --net=/var/run/netns/netns1
ip link set lo up
ip link set ceth1 up
ip addr add 172.18.0.20/16 dev ceth1
exit
```

```sh
# create bridge interface
sudo ip link add br0 type bridge

sudo ip link link set br0 up

# attach veth0 and veth1
sudo ip link set veth0 master br0
sudo ip link set veth1 master br0
```

![](https://iximiuz.com/container-networking-is-simple/bridge-4000-opt.png)

## Check connectivity

```sh
$ sudo nsenter --net=/var/run/netns/netns0
$ ping -c 2 172.18.0.20
PING 172.18.0.20 (172.18.0.20) 56(84) bytes of data.
64 bytes from 172.18.0.20: icmp_seq=1 ttl=64 time=0.259 ms
64 bytes from 172.18.0.20: icmp_seq=2 ttl=64 time=0.051 ms

--- 172.18.0.20 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 2ms
rtt min/avg/max/mdev = 0.051/0.155/0.259/0.104 ms
$ sudo nsenter --net=/var/run/netns/netns1
$ ping -c 2 172.18.0.10
PING 172.18.0.10 (172.18.0.10) 56(84) bytes of data.
64 bytes from 172.18.0.10: icmp_seq=1 ttl=64 time=0.037 ms
64 bytes from 172.18.0.10: icmp_seq=2 ttl=64 time=0.089 ms

--- 172.18.0.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 36ms
rtt min/avg/max/mdev = 0.037/0.063/0.089/0.026 ms
```

```sh
# do neighbour check inside of each netns[0-1]  
ip neigh
```

To establish the connectivity between the root and container namespaces, we need to assign the IP address to the bridge network interface:

```sh
$ sudo ip addr add 172.18.0.1/16 dev br0
```
Once we assigned the IP address to the bridge interface, we got a route on the host routing table:
```sh
$ ip route
# ... omitted lines ...
172.18.0.0/16 dev br0 proto kernel scope link src 172.18.0.1

$ ping -c 2 172.18.0.10
PING 172.18.0.10 (172.18.0.10) 56(84) bytes of data.
64 bytes from 172.18.0.10: icmp_seq=1 ttl=64 time=0.036 ms
64 bytes from 172.18.0.10: icmp_seq=2 ttl=64 time=0.049 ms

--- 172.18.0.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 11ms
rtt min/avg/max/mdev = 0.036/0.042/0.049/0.009 ms

$ ping -c 2 172.18.0.20
PING 172.18.0.20 (172.18.0.20) 56(84) bytes of data.
64 bytes from 172.18.0.20: icmp_seq=1 ttl=64 time=0.059 ms
64 bytes from 172.18.0.20: icmp_seq=2 ttl=64 time=0.056 ms

--- 172.18.0.20 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 4ms
rtt min/avg/max/mdev = 0.056/0.057/0.059/0.007 ms
```

![](https://iximiuz.com/container-networking-is-simple/router-4000-opt.png)
```sh
$ sudo iptables -t nat -A POSTROUTING -s 172.18.0.0/16 ! -o br0 -j MASQUERADE
```
The command is fairly simple. We are adding a new rule to the nat table of the POSTROUTING chain asking to masquerade all the packets originated in 172.18.0.0/16 network, but not by the bridge interface.

Check the connectivity:
```sh
$ sudo nsenter --net=/var/run/netns/netns0
$ ping -c 2 8.8.8.8
```

However, if we were to access this server from the outside world, what IP address would we use? The only IP address we might know is the host's external interface address eth0:
```sh
$ curl 10.0.2.15:5000
curl: (7) Failed to connect to 10.0.2.15 port 5000: Connection refused
Thus, we need to find a way to forward any packets arriving at port 5000 on the host's eth0 interface to 172.18.0.10:5000 destination. Or, in other words, we need to publish the container's port 5000 on the host's eth0 interface. iptables to the rescue!
```
```sh
# External traffic
sudo iptables -t nat -A PREROUTING -d 10.0.2.15 -p tcp -m tcp --dport 5000 -j DNAT --to-destination 172.18.0.10:5000

# Local traffic (since it doesn't pass the PREROUTING chain)

sudo iptables -t nat -A OUTPUT -d 10.0.2.15 -p tcp -m tcp --dport 5000 -j DNAT --to-destination 172.18.0.10:5000
```

Additionally, we need to enable iptables intercepting traffic over bridged networks:
```sh
sudo modprobe br_netfilter
# Testing time!

curl 10.0.2.15:5000
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
# ... omitted lines ...
```
