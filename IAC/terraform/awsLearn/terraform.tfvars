# subnet_prefix = "10.0.200.0/24"

# if the file name is not terraform then
# terraform apply -var-file <file name>.tfvars

# for the demo of subentes
# subnet_prefix = ["10.0.1.0/24", "10.0.2.0/24"]
subnet_prefix = [
  {
    cidr_block = "10.0.1.0/24",
    name = "prod_subnet-1"
  },
  {
    cidr_block = "10.0.2.0/24",
    name = "prod_subnet-2"
  }
]
