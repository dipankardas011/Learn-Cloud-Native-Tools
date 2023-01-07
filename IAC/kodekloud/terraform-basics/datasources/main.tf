resource "local_file" "pet" {
  filename = "/root/dscdsc.txt"
  # content  = "We love pets"
  content = data.local_file.dog.content
}


# file to be read
data "local_file" "dog" {
  filename =  "/root/dog.txt"
}


