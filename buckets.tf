#S3 bucket
resource “random_id” “id” {
    byte_length = 8
}
resource “aws_s3_bucket” “credcompromise” {
  bucket = “$(random_id.id.hex)-credcompromise”
}
resource “aws_s3_bucket_public_access_block” “public_access_block” {
  bucket = aws_s3_bucket.credcompromise.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
