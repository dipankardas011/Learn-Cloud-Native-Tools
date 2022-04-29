![](../cover.png)
# Deploy a simple server using AWS + Terraform

# Define

## What is Terraform?
Terraform is an (**IAC**)infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. 
![](https://mktg-content-api-hashicorp.vercel.app/api/assets?product=terraform&version=refs%2Fheads%2Fstable-website&asset=website%2Fimg%2Fdocs%2Fintro-terraform-apis.png)

## The core Terraform workflow
* Write: You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.
* Plan: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.
* Apply: On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.

[Link for the AWS resource definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

# How to setup AWS
## Setup Access Key
![](../01.png)
1. To create one or more IAM users (console)
  1. Sign in to the AWS Management Console and open the IAM console at [**AWS IAM**](https://console.aws.amazon.com/iam/)
  2. expand the list **Access keys (access key ID and secret access key)** ![](../02.png)
  3. **Store the keys**  ![](../03.png)
2. Installation of Terraform CLI
  [Download Link](https://www.terraform.io/downloads)

![](../04.png)

# Lets Learn by Doing
Lets get right into it

## Resources to create web server
1. EC2 - virtual machine
2. VPC - Virtual Private Cloud
3. Internet Gateway - to allow network traffic to reach the inside vpc
4. Subnet - It creates Network inside VPC thus reducing the network hopping
5. RouteTable - It stores destination addr where network traffic from your subnet or gateway is to be directed to.
6. Associate the RouteTable and Subnet - connect both of them
7. Security Group - to Allow which port and from what Client ip address it came
8. Network Interface - It allows communications between computers connected to the Subnet
9. Elastic IP - its a service by AWS which provides the dynamic IP during creation.

![](../05.png)

## Lets create simple resource
```terraform
provider "aws" {
  region  = "us-east-1"
  access_key = "<provide the keys>"
  secret_key = "<provide the keys>"
}

# 1. create vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "production"
  }
}

# 2. create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "ig"
  }
}

# 3. create custom route table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "prod-rt"
  }
}

# 4. create a subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod-vpc.id
  # cidr_block = "10.0.1.0/24"
  cidr_block = var.subnet_prefix
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

# 5. associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. create security group to allow port 22, 80, 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # so as to make anyone to reach the server
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # so as to make anyone to reach the server
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # so as to make anyone to reach the server
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

# 8. assign an elastic ip to the network interface created in step 7
resource "aws_eip" "one" {
  depends_on = [
    aws_internet_gateway.gw
  ]
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
}

output "server_public_ip" {  # it will print when terrafrom apply
  value = aws_eip.one.public_ip
}

# 9. create ubuntu server and install/enable apache2

resource "aws_instance" "web-server-ec2" {
  ami = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a" # it is hardcoded as aws will make different zones to subnet and ec2 Thus, Causing Errors
  key_name = "terraform-access-ec2"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo bash -c 'echo your very first web server > /var/www/html/index.html'
    EOF

  tags = {
    "Name" = "web-server"
  }
}
# terraform state list
# terraform state show <name of resource>

output "server_private_ip" {
  value = aws_instance.web-server-ec2.private_ip
}

output "server_id" {
  value = aws_instance.web-server-ec2.id
}

```

# References


Hope it helps
Happy coding👍🏼🥳