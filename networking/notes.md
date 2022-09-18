https://opensource.com/article/18/10/introduction-tcpdump


```bash
sudo tcpdump -i lo -nn src 127.0.0.1

# for saving the packet capture
sudo tcpdump -i any -c10 -nn -w webserver.pcap port 80

#Tcpdump creates a file in binary format so you cannot simply open it with a text editor. To read the contents of the file, execute tcpdump with the -r
tcpdump -nn -r webserver.pcap


# to print the contents of packet
# here -A is for  ascii and X is for hex
sudo tcpdump -i any -c10 -nn -A port 80
```
