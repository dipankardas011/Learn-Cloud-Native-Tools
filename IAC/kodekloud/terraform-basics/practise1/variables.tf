variable "filename" {
  type    = string
  default = "./pets.txt"
}

variable "sett" {
  default = [1, 2, 1]
  type    = set(number)
}

variable "content" {
  type    = string
  default = "YWJjZA=="
}

variable "prefix" {
  default = ["Mr", "Mrs", "Sir"]
  type    = list(string)
}

variable "length" {
  default     = 1
  type        = number
  description = "length of the pet name"
}

variable "file-content" {
  type = map(string)
  default = {
    "first_name" = "Dipankar"
    "last_name"  = "Das"
  }
}

variable "others" {
  type = object({
    name   = string
    age    = number
    food   = list(string)
    isMale = bool
  })
  default = {
    age    = 21
    food   = ["food1", "food2"]
    name   = "food"
    isMale = true
  }
}

variable "kitty" {
  type    = tuple([string, number, bool])
  default = ["cat", 1, false]
}
