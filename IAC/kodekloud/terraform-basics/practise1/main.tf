resource "local_file" "pet" {
  filename       = var.filename
  content = " hello ${random_pet.my-pet.id}"
  depends_on = [
    "random_pet.my-pet"
  ]
  # content_base64 = var.content+"${random_pet.my-pet.id}"
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

output "pet-name" {
  value = random_pet.my-pet.id
  description = "record the value of pet ID generated y the random_pet resource"
}
