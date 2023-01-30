variable "region" {
  type = map(any)
  default = {
    "us-payroll"    = "us-east-1"
    "uk-payroll"    = "eu-west-2"
    "india-payroll" = "ap-south-1"
  }

}
variable "ami" {
  type = map(any)
  default = {
    "us-payroll"    = "ami-24e140119877avm"
    "uk-payroll"    = "ami-35e140119877avm"
    "india-payroll" = "ami-55140119877avm"
  }
}
