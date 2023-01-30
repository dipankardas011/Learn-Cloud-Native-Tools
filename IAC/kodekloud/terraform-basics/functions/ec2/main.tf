resource "aws_instance" "mario_servers" {
  ami = var.ami
  instance_type = var.name == "tiny" ? var.small : var.large
  tags = {
      Name = var.name
  }
}

