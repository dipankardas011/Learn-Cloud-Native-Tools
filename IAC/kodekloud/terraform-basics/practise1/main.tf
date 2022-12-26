resource "local_file" "pet" {
  filename       = var.filename
  content_base64 = var.content
}

resource "local_sensitive_file" "name" {
  filename = "abcd.txt"
  content  = var.file-content["first_name"]
}

resource "random_pet" "my-pet" {
  prefix    = var.prefix[0]
  separator = "."
  length    = var.length
}
