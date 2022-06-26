for rdb mode 
```conf
dbfilename "dump.rdb"
```
for aof mode

```conf
appendonly yes
appendfilename "appenonly.aof"
```

where redis writes the 2 files
```conf
dir "/data"
```

to make slaves point to master
```conf
slaveof redis-0 6379
```

these containers should be inside same network and can talk to each other