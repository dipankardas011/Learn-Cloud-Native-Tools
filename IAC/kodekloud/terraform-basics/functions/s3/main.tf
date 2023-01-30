resource "aws_iam_user" "cloud" {
  name = split(":",var.cloud_users)[count.index]
  count = length(split(":",var.cloud_users))
  
}
resource "aws_s3_bucket" "sonic_media" {
  bucket = var.bucket
}

resource "aws_s3_bucket_object" "upload_sonic_media" {
  bucket = aws_s3_bucket.sonic_media.id
  for_each = var.media
  source = each.value
  key = substr(each.value, 7, 20)
}

