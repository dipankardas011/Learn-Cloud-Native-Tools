
[Link](https://learn.hashicorp.com/tutorials/vault/getting-started-policies)

# Start
```sh
vault server --dev

vault server -client=config.hcl
```

```sh
vault kv put -mount=secret creds password="my-long-password"
== Secret Path ==
secret/data/creds

======= Metadata =======
Key              Value
---              -----
created_time     2018-05-22T18:05:42.537496856Z
deletion_time    n/a
destroyed        false
version          1
```