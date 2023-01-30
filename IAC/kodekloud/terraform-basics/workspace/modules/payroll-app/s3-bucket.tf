resource "aws_s3_bucket" "payroll_data" {

  bucket = "${var.app_region}-${var.bucket}"

}
