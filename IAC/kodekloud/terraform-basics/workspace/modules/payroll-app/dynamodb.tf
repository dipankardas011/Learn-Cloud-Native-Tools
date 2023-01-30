resource "aws_dynamodb_table" "payroll_db" {
  name         = "${var.app_region}_user_data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "EmployeeID"

  attribute {
    name = "EmployeeID"
    type = "N"
  }
  attribute {
    name = "Department"
    type = "S"
  }
  attribute {
    name = "age"
    type = "N"
  }
  attribute {
    name = "Address"
    type = "S"
  }
  global_secondary_index {
    name            = "EmployeeID"
    hash_key        = "EmployeeID"
    projection_type = "ALL"

  }
  global_secondary_index {
    name            = "age"
    hash_key        = "age"
    projection_type = "ALL"

  }
  global_secondary_index {
    name            = "Department"
    hash_key        = "Department"
    projection_type = "ALL"

  }
  global_secondary_index {
    name            = "Address"
    hash_key        = "Address"
    projection_type = "ALL"

  }
}
