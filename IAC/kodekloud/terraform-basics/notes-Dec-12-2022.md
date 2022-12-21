# Simple HCL configs

```hcl
resource "aws_instance" "webserver" {
  ami           = "ami-XXYYZZ"
  instance_type = "t2.micro"
}
```

```HCL
resource "aws_s3_bucket" "data" {
  bucket  = "webservver-AW999suuXXYYZ"
  acl     = "private"
}
```

as it is a `immutable` IAC
> delete the whole infrastrucute and agin create another one with updated config


for sentive content

```hcl
resource "local_file" "games" {
  filename          = "/root/favorite-games"
  sensitive_content = "FIFA 21"
}

```
