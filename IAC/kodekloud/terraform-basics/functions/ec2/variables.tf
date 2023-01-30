variable "region" {
  default = "us-east-1"
}
variable  "name" {
  type = string
}
variable "ami" {
  type = string
  default = "ami-09331245601cf"
}
variable "small" {
  type = string
  default = "t2.nano"
}
variable "large" {
  type = string
  default = "t2.2xlarge"
}
