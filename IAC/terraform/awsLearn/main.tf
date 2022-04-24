provider "aws" {
  region  = "us-east-1"
  # access_key = "<provide the keys>"
  # secret_key = "<provide the keys>"
}

# $ export AWS_ACCESS_KEY_ID="<provide the keys>"
# $ export AWS_SECRET_ACCESS_KEY="<provide the keys>"

# resource "aws_instance" "niceUbuntuCreate" {
#   ami = "ami-04505e74c0741db8d"
#   instance_type = "t2.micro"

#   tags = {
#     "Name" = "ubuntu-terraform"
#   }
# }

variable "subnet_prefix" {
  description = "subnet cidr block"
  # default = "10.0.66.0/24"
  # type = string
  # type = list
  type = any
}

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.subnet_prefix[0].cidr_block

  tags = {
    Name = var.subnet_prefix[0].name
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = var.subnet_prefix[1].cidr_block

  tags = {
    Name = var.subnet_prefix[1].name
  }
}
# --------------------------------------------
# # first we need to set up the Key pairs to acces the resources


# # for cmd argument
# # terraform apply -var "subnet_prefix=10.0.1.0/24"
# # created a terraform.tfvars where the variable value is stored 

# # 1. create vpc
# resource "aws_vpc" "prod-vpc" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     "Name" = "production"
#   }
# }

# # 2. create internet gateway
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.prod-vpc.id

#   tags = {
#     Name = "ig"
#   }
# }

# # 3. create custom route table
# resource "aws_route_table" "prod-route-table" {
#   vpc_id = aws_vpc.prod-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     gateway_id             = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "prod-rt"
#   }
# }

# # 4. create a subnet
# resource "aws_subnet" "subnet-1" {
#   vpc_id     = aws_vpc.prod-vpc.id
#   # cidr_block = "10.0.1.0/24"
#   cidr_block = var.subnet_prefix
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "prod-subnet"
#   }
# }

# # 5. associate subnet with route table
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.prod-route-table.id
# }

# # 6. create security group to allow port 22, 80, 443
# resource "aws_security_group" "allow_web" {
#   name        = "allow_web_traffic"
#   description = "Allow Web inbound traffic"
#   vpc_id      = aws_vpc.prod-vpc.id

#   ingress {
#     description      = "HTTPS"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"] # so as to make anyone to reach the server
#   }

#   ingress {
#     description      = "HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"] # so as to make anyone to reach the server
#   }

#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"] # so as to make anyone to reach the server
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_web"
#   }
# }

# # 7. create a network interface with an ip in the subnet that was created in step 4
# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = aws_subnet.subnet-1.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]
# }

# # 8. assign an elastic ip to the network interface created in step 7
# resource "aws_eip" "one" {
#   depends_on = [
#     aws_internet_gateway.gw
#   ]
#   vpc                       = true
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.1.50"
# }

# output "server_public_ip" {  # it will print when terrafrom apply
#   value = aws_eip.one.public_ip
# }

# # 9. create ubuntu server and install/enable apache2

# resource "aws_instance" "web-server-ec2" {
#   ami = "ami-04505e74c0741db8d"
#   instance_type = "t2.micro"
#   availability_zone = "us-east-1a" # it is hardcoded as aws will make different zones to subnet and ec2 creating error
#   key_name = "terraform-access-ec2"
#   network_interface {
#     device_index = 0
#     network_interface_id = aws_network_interface.web-server-nic.id
#   }

#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install apache2 -y
#     sudo systemctl start apache2
#     sudo bash -c 'echo your very first web server > /var/www/html/index.html'
#     EOF

#   tags = {
#     "Name" = "web-server"
#   }
# }
# # terraform state list
# # terraform state show <name of resource>

# output "server_private_ip" {
#   value = aws_instance.web-server-ec2.private_ip
# }

# output "server_id" {
#   value = aws_instance.web-server-ec2.id
# }

# # ⚠️ to see a output better way is to use terraform refresh
# # terraform destroy -target <name of resource>
# # terraform apply -target <name of resource>
# # terraform destroy --auto-approve