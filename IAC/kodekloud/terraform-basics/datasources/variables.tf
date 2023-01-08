variable "filename" {
  # count
  type = list(string)

  # for_each
  # type = set(string)
  default = [
    "./pets.txt",
    "./cats.txt"
  ]
}
