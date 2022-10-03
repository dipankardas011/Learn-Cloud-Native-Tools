Installation instraction
[Link](https://tecadmin.net/install-mysql-8-on-fedora/)

```bash
kubectl create -f mysql-pvc.yaml
kubectl create -f mysql-pass.yaml
kubectl create -f mysql-service.yaml
kubectl create -f mysql.yaml

# create databsae abcd then create a table
kubectl exec -it mysql-0 -- bash
```

```sql
CREATE TABLE IF NOT EXISTS test (
  no int,
  text varchar(20)
);

INSERT INTO test VALUES (1, 'test');
```

```bash
kubectl create -f pod-agent.yaml
```