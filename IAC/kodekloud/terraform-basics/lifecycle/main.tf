resource "local_file" "pet" {
  filename = "/root/abcd.txt"
  content = "We love .."
  file_permission = "0700"

  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
# if any changes are there in configuration lead of deletion of the resource it will reject the apply command
# it only applies to config changes and subsequent applies but the resource will get deleteate when `destroy`
  }
}

resource "aws_instance" "webserver" {
  ami = "ami-00dew0dwd"
  instance_type = "t2.micro"
  tags = {
    Name = "dcdscdscsd"
  }

  lifecycle {
    # now if we apply and changes are to the tags section then terraofmr detects no changes
    ignore_changes = [
      tags
      # also all can be used to not allow any changes to the resource in it to get changed
    ]
    # or
    ignore_changes = all
  }
}