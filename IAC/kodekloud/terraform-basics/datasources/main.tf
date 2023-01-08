resource "local_file" "pet" {
  # count
  # filename = var.filename[count.index]
  # count = length(var.filename)

  # for_each
  filename = each.value
  # for_each = var.filename  # when it is set or map

  ## we can slo convert the list->set
  for_each = toset(var.filename)

  # content  = "We love pets"
  content = data.local_file.dog.content
}


# file to be read
data "local_file" "dog" {
  filename =  "./dog.txt"
}

output "pets" {
  value = local_file.pet
  sensitive = true
}
